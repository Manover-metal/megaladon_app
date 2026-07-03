# Дизайн: отзывы на детальной странице магазина

Дата: 2026-07-03

## Цель

На детальной странице магазина (`details_store_screen`) внизу показывать список
отзывов магазина — секцией, переиспользуя готовые компоненты отзывов исполнителя
(`ReviewModel`, `ReviewCard`, backend `RatingPresenter`).

## Текущее состояние

- `Store` (backend) имеет `ratings()` (`morphMany(Rating, 'ratingable')`) и `user()`.
- `RatingPresenter::list()` уже отдаёт `id, rate, comment, created_at,
  user{id,name,photo_url}, media[]` — подходит без изменений.
- Flutter: `ReviewModel` парсит этот формат; `ReviewCard` рендерит (аватар+имя,
  звёзды, комментарий/«Нет описания», список фото).
- `ExecutorReviewsCubit` (`logic/screens/executor/my_reviews/`) — образец для
  cubit'а.
- Роут-группа `store` (`middleware api`); `StoreService` использует
  `errNotFound`, `resultCollections`.
- Экран `details_store_screen` — единый `SingleChildScrollView` со своим
  `StoreScreenDetailsCubit`; секция прайс-листа внизу.

## Бэкенд (Laravel) — новый метод

1. **Роут** (в группе `store`): `Route::get('/{id}/ratings',
   [StoreController::class, 'ratings']);`
2. **`StoreController::ratings($id)`**:
   `return $this->result($this->storeService->ratings($id));`
3. **`StoreService::ratings($id)`**:
   ```php
   $store = Store::find($id);
   if (is_null($store)) {
       return $this->errNotFound(__('store.not_found'));
   }
   $ratings = $store->ratings()->with(['media', 'user'])->latest()->get();
   return $this->resultCollections($ratings, RatingPresenter::class, 'list');
   ```
   (импорт `use App\Presenters\v1\RatingPresenter;`)

Формат ответа: `{ "list": [ { id, rate, comment, created_at,
user:{id,name,photo_url}, media:[{id,url,active}] } ] }`.

## Flutter

### Data
- `ReviewRepository.storeReviews(int storeId)`:
  `ApiService.I.get('/store/$storeId/ratings')` →
  `ReviewModel.listFromJson(value.data['list'])`.

### Logic
- `logic/screens/store/reviews/store_reviews_cubit.dart` +
  `store_reviews_state.dart` — зеркало `ExecutorReviewsCubit`:
  - `StoreReviewsCubit(this.storeId)`;
  - `fetch()` → `_repository.storeReviews(storeId)` → loading/success/error;
  - state: `status {loading, error, success}`, `reviews: List<ReviewModel>`,
    `error: ErrorModel?`.

### UI (`details_store_screen`)
- Обернуть тело/`Scaffold` в
  `BlocProvider(create: (_) => StoreReviewsCubit(widget.storeId)..fetch())`.
- В `StoreScreenDetailsSuccess`-ветке, после блока прайс-листа, добавить секцию:
  - `SubTitleApp(AppLocalizations.of(context)!.reviews)` («Отзывы»);
  - `BlocBuilder<StoreReviewsCubit, StoreReviewsState>`:
    - loading → `Loader`;
    - error → `ErrorMessage`;
    - пусто → текст `no_reviews_yet` («Пока нет отзывов»);
    - список → `Column(children: reviews.map((r) => ReviewCard(review: r)))`.

### Локализация
- Новый ключ `reviews`: «Отзывы» / "Reviews" / «Пікірлер» в en/ru/kk;
  `flutter gen-l10n`. (`no_reviews_yet`, `no_description` уже есть.)

## Вне объёма (YAGNI)
- Пагинация отзывов, pull-to-refresh секции (грузим один раз при открытии).
- Отдельный экран отзывов магазина.
- Изменения `RatingPresenter`/`ReviewModel`/`ReviewCard` (переиспользуются).

## Проверка
- `php -l` изменённых бэкенд-файлов.
- `flutter analyze` новых/изменённых Flutter-файлов; `flutter gen-l10n` без ошибок.
- Ручная: открыть магазин с отзывами → секция со списком; магазин без отзывов →
  «Пока нет отзывов».
