import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/user/reviews/user_reviews_cubit.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/review/reviews_list.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';

/// Отзывы о человеке. Раньше эта секция жила прямо в экране отклика; теперь
/// её же показывает страница исполнителя, поэтому виджет вынесен.
///
/// [userId] — именно id пользователя, а не исполнителя: отзывы привязаны к
/// аккаунту. В отклике `offer.executor.id` — уже пользовательский (автора
/// отдаёт `UserPresenter::short()`), а у исполнителя для этого есть
/// отдельное поле `userId`.
class UserReviewsSection extends StatelessWidget {
  const UserReviewsSection({required this.userId, super.key});

  final int userId;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => UserReviewsCubit(userId)..fetch(),
        child: const _ReviewsView(),
      );
}

class _ReviewsView extends StatelessWidget {
  const _ReviewsView();

  Widget _content(BuildContext context, UserReviewsState state) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    switch (state.status) {
      case UserReviewsStatus.loading:
        return const Loader(padding: 10);
      case UserReviewsStatus.error:
        return ErrorMessage(error: state.error!);
      case UserReviewsStatus.success:
        if (state.reviews.isEmpty) {
          return Text(
            l10n.no_reviews_yet,
            style: TextStyle(fontSize: 13, color: scheme.secondary),
          );
        }

        return ReviewsList(reviews: state.reviews);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<UserReviewsCubit, UserReviewsState>(
      builder: (context, state) {
        final count = state.status == UserReviewsStatus.success
            ? state.reviews.length
            : null;

        return ContentSection(
          title: count == null || count == 0
              ? l10n.reviews
              : '${l10n.reviews} · $count',
          // Список отзывов состоит из собственных карточек — вторая рамка
          // вокруг них читалась бы как рябь.
          boxed: count == null || count == 0,
          child: _content(context, state),
        );
      },
    );
  }
}
