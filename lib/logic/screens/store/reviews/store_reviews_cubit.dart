import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/review_model.dart';
import 'package:megaladon/data/repositories/review_repository.dart';

part 'store_reviews_state.dart';

class StoreReviewsCubit extends Cubit<StoreReviewsState> {
  StoreReviewsCubit(this.storeId) : super(const StoreReviewsState());

  final int storeId;
  final ReviewRepository _repository = ReviewRepository();

  Future<void> fetch() async {
    emit(state.copyWith(status: StoreReviewsStatus.loading, error: null));

    return await _repository.storeReviews(storeId).then((value) {
      emit(state.copyWith(
        status: StoreReviewsStatus.success,
        reviews: value,
      ));
    }).catchError((Object error) {
      if (error is DioException) {
        emit(state.copyWith(
            status: StoreReviewsStatus.error,
            error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(
            status: StoreReviewsStatus.error, error: ErrorModel.nothing));
      }
    });
  }
}
