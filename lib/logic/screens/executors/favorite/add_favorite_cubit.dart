import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/executor_repository.dart';

part 'add_favorite_state.dart';

class AddFavoriteCubit extends Cubit<AddFavoriteState> {
  AddFavoriteCubit() : super(AddFavoriteInitial());

  final ExecutorRepository _repository = ExecutorRepository();

  Future<void> add({required int orderId, required int executorId}) async {
    if (state is AddFavoriteLoading) return;

    emit(AddFavoriteLoading());

    await _repository.addFavorite(orderId, executorId).then((_) {
      emit(AddFavoriteSuccess());
    }).catchError((Object error) {
      if (error is DioException) {
        emit(AddFavoriteError(ErrorModel.parseDio(error)));
      } else {
        emit(AddFavoriteError(ErrorModel.nothing));
      }
    });
  }
}
