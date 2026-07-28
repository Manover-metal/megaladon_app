import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/review_model.dart';
import 'package:megaladon/data/repositories/review_repository.dart';

part 'user_reviews_state.dart';

/// Отзывы произвольного пользователя. Отдельный кубит, а не режим
/// ExecutorReviewsCubit: тот живёт в logic/screens/executor/my_reviews и
/// работает только со своим профилем. В проекте такое разделение уже
/// принято — StoreReviewsCubit устроен так же.
class UserReviewsCubit extends Cubit<UserReviewsState> {
  UserReviewsCubit(this.userId) : super(const UserReviewsState());

  final int userId;
  final ReviewRepository _repository = ReviewRepository();

  Future<void> fetch() async {
    emit(state.copyWith(status: UserReviewsStatus.loading, error: null));

    return await _repository.userReviews(userId).then((value) {
      emit(state.copyWith(
        status: UserReviewsStatus.success,
        reviews: value,
      ));
    }).catchError((Object error) {
      if (error is DioException) {
        emit(state.copyWith(
            status: UserReviewsStatus.error,
            error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(
            status: UserReviewsStatus.error, error: ErrorModel.nothing));
      }
    });
  }
}
