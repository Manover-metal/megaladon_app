# Переписывание ChatCubit / ChatState на polling

Дата: 2026-07-05

## Цель
Переписать `lib/logic/screens/chats/chat_cubit.dart` и `chat_state.dart` начисто:
убрать мёртвый Pusher-код и костыли, сделать корректное иммутабельное состояние,
а обновление сообщений/чатов реализовать через **polling** (опрос бэкенда по таймеру).

## Решения (утверждено пользователем)
- **Транспорт real-time:** polling (без Pusher, без FCM-driven).
- **Скоуп опроса:** открытый чат (сообщения) + список чатов — каждый пуллится
  только пока его экран активен.
- **Интервал:** 5 секунд.
- **Бэкенд не меняем:** поллинг = перезапрос первой страницы (`startRow=0`,
  `sortBy=id desc`) + мерж по серверному `id` на клиенте (без `afterId`).
- **Вне скоупа:** Pusher/websockets, FCM-обновления, непрочитанные/бейджи.

## Состояние (`ChatState`, immutable + Equatable)
- `status: ChatScreenMainStatus` (`loading/error/success`) — статус списка.
- `chats: List<ChatModel>` — иммутабельные; сообщения хранятся по возрастанию `id`.
- `error: ErrorModel?` — ошибка списка.
- `loadingMessages: Map<int,List<MessageModel>>` — оптимистичные отправляемые (temp-id).
- `errorMessages: Map<int,List<MessageModel>>` — не отправленные.
- `olderLoading: Map<int,bool>` — идёт подгрузка старых (пагинация вверх) по чату.
- `hasMoreOlder: Map<int,bool>` — есть ли ещё старые страницы.
- `activeChatId: int?` — открытый (пуллящийся) чат.
- Удаляются: `update` (костыль), `params`, `isLoadingMessages`.
- Все коллекции пересоздаются новыми ссылками → Equatable корректно триггерит rebuild.

## ChatModel (immutable + Equatable)
- Поля `title, id, messages (asc by id), lastMessage`, `copyWith`.
- `mergeMessages(incoming)`: дедуп по `id`, пересортировка по возрастанию —
  используется и для poll (новые снизу), и для пагинации (старые сверху).

## ChatCubit
- **Lifecycle:** `initial()` по `AuthLoginState` → только `fetchChats()`.
  `_dispose()` по `AuthLogoutState` → стоп таймеров + `emit(ChatState())`.
- **Список:** `fetchChats({silent})`; `startListPolling()` / `stopListPolling()`.
- **Чат:** `openChat(id)` (грузит page0, ставит `activeChatId`, стартует таймер),
  `closeChat()`, `loadOlder(id)` (пагинация вверх, `startRow=messages.length`).
- **Отправка:** `sendMessage(chatId, text)` — оптимистично в `loadingMessages`
  (temp negative id); успех → парс `chat_message` из ответа, убрать temp,
  `mergeMessages`; ошибка → в `errorMessages`. `retryMessage(chatId, msg)`.
- **Polling:** `Timer.periodic(5s)`. Тик чата → тихий перезапрос page0 + merge.
  Тик списка → тихий `fetchChats(silent:true)`.
- **Фон:** `WidgetsBindingObserver.didChangeAppLifecycleState` — на `paused`
  гасим таймеры, на `resumed` — поднимаем активные.
- `403` при опросе → `AuthLogoutEvent`; прочие ошибки поллинга — тихо в лог.

## Правки экранов (лёгкие)
- `list_chats_screen`: `initState → startListPolling`, `dispose → stopListPolling`
  (pull-to-refresh `fetchChats()` остаётся).
- `details_chat_screen`: `initState → openChat(id)`, `dispose → closeChat`,
  скролл вверх → `loadOlder`, чтение `loadingMessages/errorMessages`.

## Репозиторий
- `ChatRepository.sendMessage` меняет возврат: парсит `value.data['chat_message']`
  в `MessageModel` (сейчас возвращает сырой `data`).

## Крайние случаи
- Дубли — дедуп по серверному `id` в `mergeMessages`.
- Гонка poll↔send — temp negative id не коллизится с server-id.
- Ошибки поллинга не роняют экран.
