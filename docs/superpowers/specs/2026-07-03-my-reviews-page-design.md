# Дизайн: страница «Мои отзывы» (отзывы исполнителя)

Дата: 2026-07-03

## Цель

Пользователь-исполнитель может открыть экран «Мои отзывы» и увидеть список
отзывов, полученных им как исполнителем. Переход — со страницы профиля, кнопка
показывается только если у пользователя есть `executor`.

Каждый отзыв показывает: автора (аватар + имя), звёзды (rate), текст
комментария (или «Нет описания», если комментарий пустой) и список
прикреплённых фотографий (если есть; если фото нет — блок фото не показывается).

## Текущее состояние

- Рейтинги хранятся полиморфно: `Rating` → `ratingable` (Executor).
  Поля: `user_id`, `rate`, `comment`; полиморфная связь `media()` (MediaFiles
  со `storage_link`).
- Отзыв создаётся через `POST /order/{id}/rate` (`OrderService::rateExecutor`).
- **Эндпоинта для получения полученных отзывов исполнителя нет** — его нужно
  создать.
- Профиль: `profile_screen.dart`, executor определяется как
  `state.user?.executor != null`.
- Роутинг: `auto_route`, группа `profile` в `router.dart`, генерация
  `router.gr.dart` через build_runner.
- Локализация: `l10n/app_{en,ru,kk}.arb` + `flutter gen-l10n`.

## Бэкенд (Laravel)

1. **Модель `Rating`**: добавить связь
   `user()` → `belongsTo(User::class, 'user_id')`.
2. **Роут**: в группе `['prefix' => 'executor', 'middleware' => 'api']`
   добавить `GET /my/ratings` → `ExecutorController@myRatings`.
3. **`ExecutorController::myRatings()`** → `ExecutorService::myRatings()`.
4. **`ExecutorService::myRatings()`**:
   - `$user = $this->apiAuthUser()`; если null → `errFobidden`.
   - найти executor по `user_id`; если null → `errFobidden` (не зарегистрирован
     как исполнитель).
   - `$ratings = $executor->ratings()->with(['media', 'user'])->latest()->get();`
   - вернуть `resultCollections($ratings, RatingPresenter::class, 'list')`.
5. **Новый `RatingPresenter`**, метод `list()`:
   ```php
   [
     'id' => $this->id,
     'rate' => $this->rate,
     'comment' => $this->comment,
     'created_at' => strtotime($this->created_at),
     'user' => [
       'id' => $this->user->id ?? null,
       'name' => $this->user->name ?? null,
       'photo' => $this->user->photo ? url($this->user->photo) : null,
     ],
     'media' => $this->presentCollections($this->media, MediaFilePresenter::class, 'list'),
   ]
   ```
   (уточнить имя поля фото у User при реализации.)

### Формат ответа
```json
{ "list": [
  { "id": 1, "rate": 5, "comment": "Отлично", "created_at": 1720000000,
    "user": { "id": 3, "name": "Иван", "photo": "https://.../a.jpg" },
    "media": [ { "id": 10, "url": "https://.../r.jpg", "active": true } ] }
] }
```

## Flutter

### Модель
`data/models/review_model.dart` — `ReviewModel`:
- `id: int`
- `rate: double` (через `Parser.toDouble`)
- `comment: String?`
- `authorName: String?`
- `authorPhoto: String?`
- `images: List<String>` (url'ы из `media[].url`)
- `createdAt: DateTime?` (опционально)
- `fromJson`, `listFromJson`.

### Data / Logic
- `ReviewRepository.myReviews()` (добавить в существующий
  `data/repositories/review_repository.dart`):
  `ApiService.I.get('/executor/my/ratings')` → `ReviewModel.listFromJson(data['list'])`.
- `logic/screens/executor/my_reviews/executor_reviews_cubit.dart` +
  `executor_reviews_state.dart` — паттерн как у `ProfileScreenCubit`:
  - state: `status {initial, loading, success, error}`, `reviews: List<ReviewModel>`,
    `error: ErrorModel?`.
  - `fetch()` → emit loading → repository → success/error.

### UI
`presentation/screens/profile/my_reviews_screen.dart` — `MyReviewsScreen`:
- `BlocProvider(create: (_) => ExecutorReviewsCubit()..fetch())`.
- AppBar: заголовок «Мои отзывы» (`my_reviews`).
- По статусу: спиннер / виджет ошибки / пусто («Пока нет отзывов»,
  `no_reviews_yet`) / `ListView.separated` карточек.
- **Карточка отзыва** (порядок сверху вниз):
  1. Строка автора: круглый аватар (или плейсхолдер-инициал, если `authorPhoto`
     пуст) + имя; справа — read-only звёзды по `rate`.
  2. Текст комментария, либо «Нет описания» (`no_description`), если `comment`
     пустой/null.
  3. Горизонтальный список фото (`images`), только если список не пуст.
- Read-only виджет звёзд: маленький собственный виджет (5 иконок,
  заполнены по `rate`); если найдётся готовый display-виджет рейтинга — переиспользовать.

### Роутинг
- Зарегистрировать `MyReviewsScreen` в группе `profile` (`router.dart`),
  запустить build_runner → появится `MyReviewsRoute`.

### Профиль
- В `profile_screen.dart` внутри блока `if (executor != null)` добавить
  `ProfileRouteTile(text: ...my_reviews, page: MyReviewsRoute())` с навигацией
  через `InitialRouter(children:[ProfileRouter(children:[MyReviewsRoute()])])`
  по образцу соседних tile.

### Локализация
Добавить в `app_en/ru/kk.arb` и прогнать `flutter gen-l10n`:
- `my_reviews`: «Мои отзывы» / "My Reviews" / «Менің пікірлерім»
- `no_reviews_yet`: «Пока нет отзывов» / "No reviews yet" / …
- `no_description`: «Нет описания» / "No description" / …

## Вне объёма (YAGNI)
- Пагинация, pull-to-refresh.
- Просмотр фото на весь экран (можно добавить позже).
- Фильтры/сортировка отзывов.

## Проверка
- Аналитика Flutter без ошибок (`flutter analyze`).
- PHP-синтаксис изменённых файлов без ошибок.
- Ручная проверка: у пользователя-исполнителя видна кнопка, экран открывается,
  отзывы грузятся; у не-исполнителя кнопки нет.
