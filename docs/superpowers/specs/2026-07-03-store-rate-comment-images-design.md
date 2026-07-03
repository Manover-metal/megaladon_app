# Дизайн: описание + картинки в оценке магазина (RateStoreModal)

Дата: 2026-07-03

## Цель

В модалке оценки магазина `RateStoreModal` добавить необязательный комментарий и
загрузку картинок (до 5), и отправлять их на бэкенд вместе с оценкой. Полностью
зеркалит уже готовую оценку заказа (`ReviewCubit` → FormData → `/order/{id}/rate`,
backend `rateExecutor`).

## Текущее состояние

- Flutter: `RateStoreModal` (в `details_store_screen.dart`) — только `StarPicker`
  + кнопка «Отправить». `RateStoreCubit.rate({storeId, value})` →
  `StoreRepository.rate(id, rate)` → `POST /store/{id}/rate` c `{'rate': rate}`.
- Backend: `RateStoreRequest` валидирует только `rate`; `StoreController::rate`
  → `StoreService::rateStore(int $storeId, float $rate)` создаёт `Rating` только
  с `rate` (без comment/media).
- Аналог (готовый): `RateOrderRequest` валидирует `rate/comment/images`;
  `rateExecutor` создаёт rating с `comment` и сохраняет `images` в media.
- `Rating` имеет `comment` (fillable) и `media()` (morphMany). Секция отзывов
  магазина уже отображает comment + фото (сделано ранее).

## Бэкенд (Laravel)

1. **`app/Http/Requests/Store/RateStoreRequest.php`** — в `rules()` добавить:
   ```php
   'comment' => ['nullable', 'string', 'max:1000'],
   'images' => ['nullable', 'array', 'max:5'],
   'images.*' => ['image'],
   ```
2. **`StoreController::rate`** — передавать весь массив:
   `return $this->result($this->storeService->rateStore($id, $data));`
3. **`StoreService::rateStore(int $storeId, array $data)`** — сигнатура
   `float $rate` → `array $data`. Создание рейтинга + сохранение изображений:
   ```php
   $rating = $store->ratings()->create([
       'user_id' => $user->id,
       'rate' => $data['rate'],
       'comment' => $data['comment'] ?? null,
   ]);

   if (isset($data['images'])) {
       foreach ($data['images'] as $image) {
           $path = $image->store('public/rating');
           $rating->media()->create([
               'storage_link' => Storage::url($path),
           ]);
       }
   }
   ```
   (`Storage` уже импортирован; остальные проверки — not_found / auth /
   cannot_rate_own / already_rated — без изменений; `event(StoreRatedEvent)`
   остаётся.)

## Flutter

1. **`StoreRepository.rate`** — сигнатуру `rate(int id, int rate)` →
   `rate(int id, FormData data)`:
   ```dart
   Future rate(int id, FormData data) =>
       ApiService.I.post('/store/$id/rate', data: data).then((v) => v.data);
   ```
2. **`RateStoreCubit.rate`** — параметры
   `{required int storeId, required int value, required String comment,
   required List<PlatformFile> images}`; собрать FormData как в
   `ReviewCubit.submit`:
   ```dart
   final files = <MultipartFile>[];
   for (final file in images) {
     if (file.path != null) {
       files.add(await MultipartFile.fromFile(file.path!, filename: file.name));
     }
   }
   final data = FormData.fromMap({
     'rate': value,
     if (comment.trim().isNotEmpty) 'comment': comment.trim(),
   });
   for (final file in files) {
     data.files.add(MapEntry('images[]', file));
   }
   ```
   → `_repository.rate(storeId, data)`.
3. **`RateStoreModal`** (`details_store_screen.dart`) — добавить:
   - `TextEditingController _commentController`;
   - `ImageMultiPickerController _imagesController`;
   - в build: `TextFieldApp(label: comment_optional, controller: _commentController,
     maxLines: 4)` + `ImageMultiPicker(controller: _imagesController, maxCount: 5)`;
   - `_rate()` передаёт `comment: _commentController.text`,
     `images: _imagesController.value`;
   - dispose обоих контроллеров;
   - контент обернуть с отступом по `MediaQuery.viewInsets.bottom` (клавиатура),
     при необходимости — прокрутка.

## Переиспользуем
`TextFieldApp`, `ImageMultiPicker`/`ImageMultiPickerController`, ключ
`comment_optional` — уже существуют (из экрана оценки заказа).

## Вне объёма (YAGNI)
- Локальный предпросмотр отправленных фото до перезагрузки секции отзывов.
- Редактирование существующей оценки.

## Проверка
- `php -l` изменённых бэкенд-файлов.
- `flutter analyze` изменённых Flutter-файлов.
- Ручная: оценить магазин с комментарием и фото → секция отзывов (после
  пересборки бэкенда) показывает их.
