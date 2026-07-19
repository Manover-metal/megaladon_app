# Фильтр по статусу заказа — дизайн

Дата: 2026-07-19
Область: `megaladon_app` (Flutter). Бэкенд (`megaladon_back`, Laravel) изменений не требует.

## Цель

Дать пользователю фильтровать списки заказов по статусу на всех экранах-списках заказов.

## Что уже готово (не трогаем)

- **Бэкенд** уже принимает фильтр: `OrderRepo::applyFilterQuery` читает `status` (одиночный int) и `statuses[]` (массив int) и фильтрует `orders.status`. Эндпоинты: `GET /order`, `GET /order/my`, `GET /order/my-responded`. Изменений на бэке нет.
- **Клиентский параметр** уже уходит в запрос: `OrderIndexRequestParams.toData()` сериализует `statuses` как список int (`'statuses': statuses.map((s) => s.index).toList()`). В UI выбор статуса просто не выведен.

## Статусы (enum `OrderStatus`, `lib/data/models/order_model.dart`)

Индекс = wire-формат: `nothing=0, moderate=1, active=2, hasExecutor=3, completed=4, archive=5`.
Пользовательские лейблы: На проверке (moderate), Активный (active), В работе (hasExecutor), Выполнен (completed), Архив (archive). `nothing` — служебный, в фильтре не показывается.

## Решения (утверждено с пользователем)

- **Размещение:** секция «Статус» внутри существующих bottom-sheet'ов фильтра. Отдельных чипов на экране нет.
- **Выбор:** одиночный (single-select) через `CupertinoPicker`, как `IndexPeriodPicker` для периода. Выбранный статус пишется в `params.statuses` списком из одного элемента. Пункт «Все» сбрасывает `statuses` на дефолт экрана.
- **Набор статусов различается по экранам:**

| Экран | Cubit | «Все» = | Отдельные пункты |
|---|---|---|---|
| Общая лента (`ListOrdersScreen`) | `OrderScreenMainCubit` | `[active, hasExecutor, completed]` (текущий дефолт) | Активный, В работе, Выполнен |
| Мои заказы (`ListMyOrdersScreen`) | `OrderScreenMyCubit` | `OrderStatus.values` (все) | На проверке, Активный, В работе, Выполнен, Архив |

Обоснование: в публичной ленте `moderate` и `archive` показывать не нужно; в «Моих» нужны все.

## Компоненты и изменения

1. **`OrderStatus.localize(AppLocalizations l10n)`** — метод/extension для лейблов, по образцу `OrderIndexSort.localize` (`lib/data/models/request/order_index_sort_enum.dart`) и `IndexPeriod.localize`. Файл: `lib/data/models/order_model.dart`.

2. **Локализация** (`lib/l10n/app_{en,ru,kk}.arb`): добавить ключи `status`, `all`, и недостающие лейблы статусов (`moderate`, `completed`; `active` / `in_work` / `archive` уже есть — переиспользовать). Регенерация `AppLocalizations` (`flutter gen-l10n` / build).

3. **`StatusPicker` + `StatusPickerController`** — новый виджет одиночного выбора на `CupertinoPicker`, по образцу `lib/presentation/widgets/form/picker/last_day_picker.dart`. Принимает список допустимых `OrderStatus` (различается по экрану) и включает виртуальный пункт «Все». `ValueNotifier`-контроллер, как `IndexPeriodPickerController`.

4. **`OrderIndexRequestParams`** (`lib/data/models/request/params/index/order_index_request_params.dart`) — убедиться, что `statuses` проходит через `copyWith`/`copyWithNull`, чтобы фильтр применялся и сбрасывал `startRow: 0` (как остальные поля).

5. **Bottom-sheet'ы** — вставить секцию `StatusPicker`:
   - `lib/presentation/widgets/bottom_sheet/filters/filter_order_bottom_sheet.dart` (набор публичной ленты)
   - `lib/presentation/widgets/bottom_sheet/filters/filter_order_my_bottom_sheet.dart` (полный набор)
   - В `initState`: seed контроллера из `cubit.state.params.statuses` (если совпадает с дефолтом экрана → «Все»; если ровно один статус → он; иначе → «Все»).
   - В `_back()`: записать выбор в `params` через `copyWithNull(..., statuses: ...)` и `pop(true)` — экран перечитает список.

## Поток данных

Пользователь открывает фильтр → выбирает статус в `StatusPicker` → «Применить» → `cubit.changeParams(params.copyWithNull(startRow: 0, statuses: selected))` → `pop(true)` → экран вызывает `refresh()`/`fetch()` → репозиторий шлёт `statuses[]` → бэкенд фильтрует → карточки перерисовываются.

## Тестирование

Виджет-тест (`WidgetTester`) для одного из bottom-sheet'ов: рендер → выбор конкретного статуса → тап «Применить» → проверка, что `changeParams` вызван с `statuses == [выбранный]`; выбор «Все» → `statuses == дефолт экрана`. Существующих тестов на фильтры нет; следовать общему паттерну виджет-тестов проекта.

## Вне области

- Мультивыбор статусов (осознанно отклонён в пользу single-select).
- Чипы статусов на самом экране.
- Экран `ListExecutorsScreen` (в папке `screens/orders/`, но это список офферов, не заказов).
- Любые изменения бэкенда.
