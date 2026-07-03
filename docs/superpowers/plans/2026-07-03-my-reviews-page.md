# My Reviews Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Экран «Мои отзывы»: исполнитель видит список полученных отзывов (автор, звёзды, комментарий, фото); переход со страницы профиля.

**Architecture:** Новый бэкенд-эндпоинт `GET /executor/my/ratings` (Laravel) возвращает отзывы текущего исполнителя. Flutter: модель `ReviewModel`, метод репозитория, `ExecutorReviewsCubit`, экран `MyReviewsScreen` (локальный BlocProvider), кнопка на профиле.

**Tech Stack:** Laravel (PHP), Flutter (Dart), flutter_bloc/cubit, auto_route, dio, cached_network_image, ARB-локализация.

## Global Constraints

- Backend package: `megaladon_back`. Frontend package: `megaladon_app`, Dart import prefix `package:megaladon/...`.
- Роуты во Flutter генерируются: `flutter pub run build_runner build --delete-conflicting-outputs` (создаёт `router.gr.dart`).
- Локализация: править `lib/l10n/app_en.arb` (шаблон, с `@`-метадатой), `app_ru.arb`, `app_kk.arb`; затем `flutter gen-l10n`.
- Парсинг чисел из JSON — через `Parser.toDouble` / `Parser.toInt` (`lib/core/utils/parser.dart`).
- Ошибки Cubit: `ErrorModel.parseDio(DioException)` либо `ErrorModel.nothing`.
- Нет git-репозитория — шаги коммитов пропускаются, вместо коммита выполняется проверка (analyze / `php -l`).
- Фото пользователя в User (backend) — поле `photo_url` (уже с `Storage::url`), в презентере оборачивается `url(...)`.

---

### Task 1: Backend — эндпоинт `GET /executor/my/ratings`

**Files:**
- Modify: `megaladon_back/app/Models/Rating.php`
- Create: `megaladon_back/app/Presenters/v1/RatingPresenter.php`
- Modify: `megaladon_back/app/Services/v1/ExecutorService.php`
- Modify: `megaladon_back/app/Http/Controllers/Api/v1/ExecutorController.php`
- Modify: `megaladon_back/routes/api.php`

**Interfaces:**
- Produces: `GET /executor/my/ratings` (middleware `api`) → JSON `{ "list": [ { id, rate, comment, created_at, user:{id,name,photo_url}, media:[{id,url,active}] } ] }`.

- [ ] **Step 1: Добавить связь `user()` в модель Rating**

В `megaladon_back/app/Models/Rating.php`, после метода `media()`, добавить:

```php
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
```

И убедиться, что вверху есть `use` для User (в этом файле namespace `App\Models`, поэтому `User` доступен без импорта — он в том же namespace).

- [ ] **Step 2: Создать RatingPresenter**

Создать `megaladon_back/app/Presenters/v1/RatingPresenter.php`:

```php
<?php

namespace App\Presenters\v1;

use App\Presenters\BasePresenter;

class RatingPresenter extends BasePresenter
{
    public function list()
    {
        return [
            'id' => $this->id,
            'rate' => $this->rate,
            'comment' => $this->comment,
            'created_at' => $this->created_at ? strtotime($this->created_at) : null,
            'user' => [
                'id' => $this->user->id ?? null,
                'name' => $this->user->name ?? null,
                'photo_url' => ($this->user && $this->user->photo_url)
                    ? url($this->user->photo_url)
                    : null,
            ],
            'media' => $this->presentCollections($this->media, MediaFilePresenter::class, 'list'),
        ];
    }
}
```

- [ ] **Step 3: Добавить метод `myRatings()` в ExecutorService**

В `megaladon_back/app/Services/v1/ExecutorService.php` добавить метод (и импорт `use App\Presenters\v1\RatingPresenter;` вверху рядом с другими use):

```php
    public function myRatings()
    {
        $user = $this->apiAuthUser();
        if (is_null($user)) {
            return $this->errFobidden(__('executor.auth_error'));
        }

        $executor = $this->executorRepo->findByUserId($user->id);
        if (is_null($executor)) {
            return $this->errFobidden(__('executor.not_registered'));
        }

        $ratings = $executor->ratings()->with(['media', 'user'])->latest()->get();

        return $this->resultCollections($ratings, RatingPresenter::class, 'list');
    }
```

- [ ] **Step 4: Добавить экшен в ExecutorController**

В `megaladon_back/app/Http/Controllers/Api/v1/ExecutorController.php` добавить метод:

```php
    public function myRatings()
    {
        return $this->result($this->executorService->myRatings());
    }
```

- [ ] **Step 5: Зарегистрировать роут**

В `megaladon_back/routes/api.php`, в группе `['prefix' => 'executor', 'middleware' => 'api']` (рядом с `/favorite`), добавить:

```php
        Route::get('/my/ratings', [ExecutorController::class, 'myRatings']);
```

- [ ] **Step 6: Проверить синтаксис PHP**

Run:
```bash
cd /Users/aleksandrbangert/projects/megaladon/megaladon_back && \
php -l app/Models/Rating.php && \
php -l app/Presenters/v1/RatingPresenter.php && \
php -l app/Services/v1/ExecutorService.php && \
php -l app/Http/Controllers/Api/v1/ExecutorController.php && \
php -l routes/api.php
```
Expected: `No syntax errors detected` для каждого файла.

- [ ] **Step 7 (по возможности): Проверить роут артизаном**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_back && php artisan route:list --path=executor/my/ratings 2>/dev/null | cat`
Expected: строка с `GET|HEAD executor/my/ratings`. (Если artisan/окружение недоступно локально — пропустить, синтаксис уже проверен.)

---

### Task 2: Flutter — модель `ReviewModel` + unit-тест

**Files:**
- Create: `megaladon_app/lib/data/models/review_model.dart`
- Test: `megaladon_app/test/data/models/review_model_test.dart`

**Interfaces:**
- Produces: `ReviewModel { int id; double rate; String? comment; String? authorName; String? authorPhoto; List<String> images; DateTime? createdAt; }`, статический `ReviewModel.fromJson(Map)`, `ReviewModel.listFromJson(List)`.

- [ ] **Step 1: Написать падающий тест**

Создать `megaladon_app/test/data/models/review_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/review_model.dart';

void main() {
  test('fromJson парсит рейтинг, автора и список фото', () {
    final review = ReviewModel.fromJson({
      'id': 7,
      'rate': '4.5',
      'comment': 'Отлично',
      'user': {'name': 'Иван', 'photo_url': 'https://x/a.jpg'},
      'media': [
        {'url': 'https://x/1.jpg'},
        {'url': 'https://x/2.jpg'},
      ],
    });

    expect(review.id, 7);
    expect(review.rate, 4.5);
    expect(review.comment, 'Отлично');
    expect(review.authorName, 'Иван');
    expect(review.authorPhoto, 'https://x/a.jpg');
    expect(review.images, ['https://x/1.jpg', 'https://x/2.jpg']);
  });

  test('fromJson без комментария, автора и фото даёт пустые значения', () {
    final review = ReviewModel.fromJson({'id': 1, 'rate': 3});

    expect(review.comment, isNull);
    expect(review.authorName, isNull);
    expect(review.images, isEmpty);
  });
}
```

- [ ] **Step 2: Запустить тест — убедиться, что падает**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_app && flutter test test/data/models/review_model_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:megaladon/data/models/review_model.dart'`.

- [ ] **Step 3: Реализовать модель**

Создать `megaladon_app/lib/data/models/review_model.dart`:

```dart
import 'package:megaladon/core/utils/parser.dart';

class ReviewModel {
  ReviewModel({
    required this.id,
    required this.rate,
    this.comment,
    this.authorName,
    this.authorPhoto,
    this.images = const [],
    this.createdAt,
  });

  final int id;
  final double rate;
  final String? comment;
  final String? authorName;
  final String? authorPhoto;
  final List<String> images;
  final DateTime? createdAt;

  static ReviewModel fromJson(Map<String, dynamic> data) {
    final user = data['user'] as Map<String, dynamic>?;
    final media = data['media'] as List<dynamic>?;
    final createdAt = data['created_at'];

    return ReviewModel(
      id: Parser.toInt(data['id']),
      rate: Parser.toDouble(data['rate']),
      comment: (data['comment'] as String?)?.trim().isNotEmpty == true
          ? data['comment'] as String
          : null,
      authorName: user?['name'] as String?,
      authorPhoto: user?['photo_url'] as String?,
      images: media == null
          ? const []
          : media
              .map((e) => (e as Map<String, dynamic>)['url'] as String?)
              .whereType<String>()
              .toList(),
      createdAt: createdAt is int
          ? DateTime.fromMillisecondsSinceEpoch(createdAt * 1000)
          : null,
    );
  }

  static List<ReviewModel> listFromJson(List<dynamic> data) => data
      .map<ReviewModel>((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
      .toList();
}
```

- [ ] **Step 4: Запустить тест — убедиться, что проходит**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_app && flutter test test/data/models/review_model_test.dart`
Expected: PASS (2 теста).

---

### Task 3: Flutter — метод репозитория `myReviews()`

**Files:**
- Modify: `megaladon_app/lib/data/repositories/review_repository.dart`

**Interfaces:**
- Consumes: `ReviewModel.listFromJson` (Task 2).
- Produces: `ReviewRepository.myReviews() → Future<List<ReviewModel>>`.

- [ ] **Step 1: Добавить метод в репозиторий**

Заменить содержимое `megaladon_app/lib/data/repositories/review_repository.dart` на:

```dart
import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/review_model.dart';

class ReviewRepository {
  Future<void> review(int id, FormData data) =>
      ApiService.I.post<dynamic>('/order/$id/rate', data: data);

  Future<List<ReviewModel>> myReviews() => ApiService.I
      .get<dynamic>('/executor/my/ratings')
      .then((value) => ReviewModel.listFromJson(
          value.data['list'] as List<dynamic>));
}
```

- [ ] **Step 2: Проверить анализ**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_app && flutter analyze lib/data/repositories/review_repository.dart`
Expected: `No issues found!`

---

### Task 4: Flutter — `ExecutorReviewsCubit` + state

**Files:**
- Create: `megaladon_app/lib/logic/screens/executor/my_reviews/executor_reviews_cubit.dart`
- Create: `megaladon_app/lib/logic/screens/executor/my_reviews/executor_reviews_state.dart`

**Interfaces:**
- Consumes: `ReviewRepository.myReviews()` (Task 3), `ReviewModel` (Task 2).
- Produces: `ExecutorReviewsCubit` с `fetch()`; `ExecutorReviewsState { ExecutorReviewsStatus status; List<ReviewModel> reviews; ErrorModel? error; }`; enum `ExecutorReviewsStatus { loading, error, success }`.

- [ ] **Step 1: Создать state**

Создать `megaladon_app/lib/logic/screens/executor/my_reviews/executor_reviews_state.dart`:

```dart
part of 'executor_reviews_cubit.dart';

enum ExecutorReviewsStatus { loading, error, success }

class ExecutorReviewsState extends Equatable {
  const ExecutorReviewsState({
    this.status = ExecutorReviewsStatus.loading,
    this.reviews = const [],
    this.error,
  });

  final ExecutorReviewsStatus status;
  final List<ReviewModel> reviews;
  final ErrorModel? error;

  @override
  List<Object?> get props => [status, reviews, error];

  ExecutorReviewsState copyWith({
    ExecutorReviewsStatus? status,
    List<ReviewModel>? reviews,
    ErrorModel? error,
  }) =>
      ExecutorReviewsState(
        status: status ?? this.status,
        reviews: reviews ?? this.reviews,
        error: error,
      );
}
```

- [ ] **Step 2: Создать cubit**

Создать `megaladon_app/lib/logic/screens/executor/my_reviews/executor_reviews_cubit.dart`:

```dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/review_model.dart';
import 'package:megaladon/data/repositories/review_repository.dart';

part 'executor_reviews_state.dart';

class ExecutorReviewsCubit extends Cubit<ExecutorReviewsState> {
  ExecutorReviewsCubit() : super(const ExecutorReviewsState());

  final ReviewRepository _repository = ReviewRepository();

  Future fetch() async {
    emit(state.copyWith(status: ExecutorReviewsStatus.loading, error: null));

    return await _repository.myReviews().then((value) {
      emit(state.copyWith(
        status: ExecutorReviewsStatus.success,
        reviews: value,
      ));
    }).catchError((error) {
      if (error is DioException) {
        emit(state.copyWith(
            status: ExecutorReviewsStatus.error,
            error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(
            status: ExecutorReviewsStatus.error, error: ErrorModel.nothing));
      }
    });
  }
}
```

- [ ] **Step 3: Проверить анализ**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_app && flutter analyze lib/logic/screens/executor/my_reviews`
Expected: `No issues found!`

---

### Task 5: Локализация — ключи для экрана

**Files:**
- Modify: `megaladon_app/lib/l10n/app_en.arb`
- Modify: `megaladon_app/lib/l10n/app_ru.arb`
- Modify: `megaladon_app/lib/l10n/app_kk.arb`

**Interfaces:**
- Produces: геттеры `my_reviews`, `no_reviews_yet`, `no_description` в `AppLocalizations`.

- [ ] **Step 1: Добавить ключи в шаблон en**

В `megaladon_app/lib/l10n/app_en.arb` добавить (перед закрывающей `}`, с запятой после предыдущего ключа):

```json
  "my_reviews": "My Reviews",
  "@my_reviews": {},
  "no_reviews_yet": "No reviews yet",
  "@no_reviews_yet": {},
  "no_description": "No description",
  "@no_description": {}
```

- [ ] **Step 2: Добавить ключи в ru**

В `megaladon_app/lib/l10n/app_ru.arb` добавить:

```json
  "my_reviews": "Мои отзывы",
  "no_reviews_yet": "Пока нет отзывов",
  "no_description": "Нет описания"
```

- [ ] **Step 3: Добавить ключи в kk**

В `megaladon_app/lib/l10n/app_kk.arb` добавить:

```json
  "my_reviews": "Менің пікірлерім",
  "no_reviews_yet": "Әзірге пікірлер жоқ",
  "no_description": "Сипаттама жоқ"
```

- [ ] **Step 4: Сгенерировать локализацию**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_app && flutter gen-l10n`
Expected: без ошибок; в `lib/generated/l10n/app_localizations.dart` появятся `String get my_reviews`, `no_reviews_yet`, `no_description`.

Проверить: `grep -c "my_reviews\|no_reviews_yet\|no_description" lib/generated/l10n/app_localizations.dart`
Expected: число ≥ 3.

---

### Task 6: Flutter — виджеты звёзд и карточки отзыва

**Files:**
- Create: `megaladon_app/lib/presentation/widgets/rating/rating_stars.dart`
- Create: `megaladon_app/lib/presentation/widgets/card/review_card.dart`

**Interfaces:**
- Consumes: `ReviewModel` (Task 2), ключ `no_description` (Task 5).
- Produces: `RatingStars({required double rate})`, `ReviewCard({required ReviewModel review})`.

- [ ] **Step 1: Создать read-only виджет звёзд**

Создать `megaladon_app/lib/presentation/widgets/rating/rating_stars.dart`:

```dart
import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({required this.rate, this.size = 18, super.key});

  final double rate;
  final double size;

  @override
  Widget build(BuildContext context) {
    final rounded = rate.round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < rounded ? Icons.star : Icons.star_border,
          size: size,
          color: Colors.amber,
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Создать карточку отзыва**

Создать `megaladon_app/lib/presentation/widgets/card/review_card.dart`:

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/review_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/rating/rating_stars.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({required this.review, super.key});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final name = review.authorName ?? '';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        border: Border.all(
            color: Theme.of(context).colorScheme.primary, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Автор + звёзды
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage:
                    (review.authorPhoto != null && review.authorPhoto!.isNotEmpty)
                        ? CachedNetworkImageProvider(review.authorPhoto!)
                        : null,
                child: (review.authorPhoto == null || review.authorPhoto!.isEmpty)
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              RatingStars(rate: review.rate),
            ],
          ),
          const SizedBox(height: 10),
          // Комментарий или «Нет описания»
          Text(
            review.comment ?? AppLocalizations.of(context)!.no_description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: review.comment == null
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                  fontStyle:
                      review.comment == null ? FontStyle.italic : FontStyle.normal,
                ),
          ),
          // Фото (если есть)
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: review.images[index],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 80,
                      height: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    errorWidget: (_, __, ___) => const SizedBox(
                      width: 80,
                      height: 80,
                      child: Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Проверить анализ**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_app && flutter analyze lib/presentation/widgets/rating/rating_stars.dart lib/presentation/widgets/card/review_card.dart`
Expected: `No issues found!`

---

### Task 7: Flutter — экран `MyReviewsScreen` + регистрация роута

**Files:**
- Create: `megaladon_app/lib/presentation/screens/profile/my_reviews_screen.dart`
- Modify: `megaladon_app/lib/presentation/routing/router.dart`
- Regenerate: `megaladon_app/lib/presentation/routing/router.gr.dart` (build_runner)

**Interfaces:**
- Consumes: `ExecutorReviewsCubit` (Task 4), `ReviewCard` (Task 6), ключи `my_reviews`/`no_reviews_yet` (Task 5).
- Produces: `MyReviewsScreen`, сгенерированный `MyReviewsRoute` (для Task 8).

- [ ] **Step 1: Создать экран**

Создать `megaladon_app/lib/presentation/screens/profile/my_reviews_screen.dart`:

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/executor/my_reviews/executor_reviews_cubit.dart';
import 'package:megaladon/presentation/widgets/card/review_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => ExecutorReviewsCubit()..fetch(),
        child: Builder(
          builder: (context) => Scaffold(
            appBar: HeaderAppBar(
              isBack: true,
              title: AppLocalizations.of(context)!.my_reviews,
            ),
            body: RefreshIndicator(
              onRefresh: () =>
                  context.read<ExecutorReviewsCubit>().fetch(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<ExecutorReviewsCubit,
                      ExecutorReviewsState>(
                    builder: (context, state) {
                      if (state.status == ExecutorReviewsStatus.loading) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Loader(padding: 10),
                        );
                      }
                      if (state.status == ExecutorReviewsStatus.error) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: ErrorMessage(error: state.error!),
                        );
                      }
                      if (state.reviews.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.no_reviews_yet,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: state.reviews
                            .map((review) => ReviewCard(review: review))
                            .toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
```

- [ ] **Step 2: Зарегистрировать роут в router.dart**

В `megaladon_app/lib/presentation/routing/router.dart`:

1. Добавить импорт рядом с другими `profile`-экранами:
```dart
import 'package:megaladon/presentation/screens/profile/my_reviews_screen.dart';
```
2. В константу `profile` добавить строку (с гардом авторизации, как у ChangeExecutorScreen):
```dart
  AutoRoute(page: MyReviewsScreen, guards: [AuthGuard]),
```

- [ ] **Step 3: Перегенерировать роуты**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_app && flutter pub run build_runner build --delete-conflicting-outputs`
Expected: `Succeeded`; в `lib/presentation/routing/router.gr.dart` появляется класс `MyReviewsRoute`.

Проверить: `grep -c "MyReviewsRoute" lib/presentation/routing/router.gr.dart`
Expected: ≥ 1.

- [ ] **Step 4: Проверить анализ экрана**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_app && flutter analyze lib/presentation/screens/profile/my_reviews_screen.dart`
Expected: `No issues found!`

---

### Task 8: Flutter — кнопка перехода на странице профиля

**Files:**
- Modify: `megaladon_app/lib/presentation/screens/profile/profile_screen.dart`

**Interfaces:**
- Consumes: `MyReviewsRoute` (Task 7), ключ `my_reviews` (Task 5), существующий `ProfileRouteTile`.

- [ ] **Step 1: Добавить tile для исполнителя**

В `megaladon_app/lib/presentation/screens/profile/profile_screen.dart`, в секции с `ProfileRouteTile` (рядом с блоком `if (executor != null) ProfileRouteTile(... change_executor ...)`), добавить перед tile «change_executor»:

```dart
                              if (executor != null)
                                ProfileRouteTile(
                                    text: AppLocalizations.of(context)!
                                        .my_reviews,
                                    page: const InitialRouter(children: [
                                      ProfileRouter(children: [MyReviewsRoute()])
                                    ])),
```

(`InitialRouter`, `ProfileRouter`, `MyReviewsRoute` доступны через уже импортированный `package:megaladon/presentation/routing/router.dart`.)

- [ ] **Step 2: Финальная проверка анализа проекта**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_app && flutter analyze lib/presentation/screens/profile/profile_screen.dart`
Expected: `No issues found!`

- [ ] **Step 3: Прогнать все тесты**

Run: `cd /Users/aleksandrbangert/projects/megaladon/megaladon_app && flutter test`
Expected: все тесты проходят (включая `review_model_test.dart`).

---

## Ручная проверка (после реализации)

- Залогиниться пользователем-исполнителем → в профиле виден пункт «Мои отзывы» → тап открывает экран со списком отзывов.
- Отзыв без комментария показывает «Нет описания»; отзыв без фото — без блока фото; отзыв с несколькими фото — горизонтальный список.
- У пользователя без `executor` пункта «Мои отзывы» нет.
- Pull-to-refresh перезагружает список.

## Self-Review

- **Покрытие спеки:** бэкенд-эндпоинт (Task 1), модель+парсинг (Task 2), репозиторий (Task 3), cubit (Task 4), локализация (Task 5), звёзды+карточка с порядком «автор→комментарий→фото» (Task 6), экран+роут (Task 7), кнопка на профиле только для executor (Task 8). Все пункты спеки покрыты.
- **Плейсхолдеры:** отсутствуют — во всех шагах приведён реальный код/команды.
- **Согласованность типов:** `ReviewModel` (поля `rate:double`, `comment:String?`, `authorName/authorPhoto:String?`, `images:List<String>`) единообразно используется в Tasks 3/4/6; `ExecutorReviewsCubit.fetch()` и `ExecutorReviewsStatus` совпадают между Tasks 4 и 7; `MyReviewsRoute`/`MyReviewsScreen` — между Tasks 7 и 8; ключи локализации `my_reviews`/`no_reviews_yet`/`no_description` — между Tasks 5, 6, 7.
