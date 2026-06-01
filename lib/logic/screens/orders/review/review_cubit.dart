import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/review_repository.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(this._repository) : super(ReviewInitial());

  final ReviewRepository _repository;

  Future<void> submit(int orderId, int rate) async {
    if (state is ReviewLoading) return;

    emit(ReviewLoading());

    await _repository.review(orderId, rate).then((_) {
      emit(ReviewSuccess());
    }).catchError((Object error) {
      if (error is DioException) {
        emit(ReviewError(ErrorModel.parseDio(error)));
      } else {
        emit(ReviewError(ErrorModel.nothing));
      }
    });
  }
}
