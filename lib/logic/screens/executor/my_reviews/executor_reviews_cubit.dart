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

  Future<void> fetch() async {
    emit(state.copyWith(status: ExecutorReviewsStatus.loading, error: null));

    return await _repository.myReviews().then((value) {
      emit(state.copyWith(
        status: ExecutorReviewsStatus.success,
        reviews: value,
      ));
    }).catchError((Object error) {
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
