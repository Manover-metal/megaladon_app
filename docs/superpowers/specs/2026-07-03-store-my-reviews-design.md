# Дизайн: отзывы своего магазина в профиле

Дата: 2026-07-03

## Цель

В профиле (для пользователя-магазина) добавить экран со списком полученных
отзывов магазина — как «Мои отзывы» у исполнителя. Переход по кнопке, видимой
только если у пользователя есть `store`.

## Текущее состояние

- Executor-аналог: кнопка `my_reviews` на профиле (`if (executor != null)`) →
  `MyReviewsScreen` (`BlocProvider(ExecutorReviewsCubit..fetch())` → список
  `ReviewCard`).
- Магазин: `StoreReviewsCubit(int storeId)` **уже существует**
  (`logic/screens/store/reviews/`), тянет `GET /store/{id}/ratings` через
  `ReviewRepository.storeReviews(storeId)`.
- В профиле доступен `store` (`state.user?.store`), у `StoreModel` есть
  `final int id`.
- Роутинг: группа `profile` в `router.dart`, генерация через build_runner.

## Бэкенд
Изменений нет — переиспользуем `GET /store/{id}/ratings` с `store.id` текущего
пользователя.

## Flutter

### Экран
`presentation/screens/store/store_my_reviews_screen.dart` —
`StoreMyReviewsScreen`:
- `const StoreMyReviewsScreen({required this.storeId, super.key});
  final int storeId;` (StatelessWidget).
- `BlocProvider(create: (_) => StoreReviewsCubit(storeId)..fetch())`.
- AppBar: заголовок `store_reviews` («Отзывы магазина»).
- `RefreshIndicator` (onRefresh → `context.read<StoreReviewsCubit>().fetch()`),
  `SingleChildScrollView` + `Container(minHeight)` + `BlocBuilder<StoreReviewsCubit,
  StoreReviewsState>`:
  - `StoreReviewsStatus.loading` → `Loader`;
  - `StoreReviewsStatus.error` → `ErrorMessage(error: state.error!)`;
  - пусто → текст `no_reviews_yet`;
  - список → `Column(children: reviews.map((r) => ReviewCard(review: r)))`.

  (Структура — копия `MyReviewsScreen`, но с `StoreReviewsCubit(storeId)` и
  заголовком `store_reviews`.)

### Роутинг
- `AutoRoute(page: StoreMyReviewsScreen, guards: [AuthGuard])` в константе
  `profile` (`router.dart`), импорт экрана; `build_runner` → `StoreMyReviewsRoute`
  (с параметром `storeId`).

### Профиль
- В `profile_screen.dart` рядом с блоком `if (store != null)
  ProfileRouteTile(...change_store...)` добавить:
  ```dart
  if (store != null)
    ProfileRouteTile(
        text: AppLocalizations.of(context)!.store_reviews,
        page: InitialRouter(children: [
          ProfileRouter(children: [StoreMyReviewsRoute(storeId: store.id)])
        ])),
  ```
  (без `const` — `storeId` динамический.)

### Локализация
- Новый ключ `store_reviews`: «Отзывы магазина» / "Store reviews" /
  «Дүкен пікірлері» в en/ru/kk; `flutter gen-l10n`.

## Переиспользуем
`StoreReviewsCubit`, `ReviewCard`, эндпоинт `GET /store/{id}/ratings` —
уже готовы.

## Вне объёма (YAGNI)
- Пагинация отзывов.
- Обобщение `MyReviewsScreen` и `StoreMyReviewsScreen` в один виджет
  (оставляем раздельно, как в кодовой базе).

## Проверка
- `flutter analyze` новых/изменённых файлов; `flutter gen-l10n` и `build_runner`
  без ошибок.
- Ручная: у пользователя-магазина виден пункт «Отзывы магазина» → экран со
  списком; без `store` пункта нет.
