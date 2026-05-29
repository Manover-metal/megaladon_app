import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';

part 'advert_delete_state.dart';

class AdvertDeleteCubit extends Cubit<AdvertDeleteState> {
  AdvertDeleteCubit() : super(AdvertDeleteInitial());

  final AdvertRepository _repository = AdvertRepository();

  Future<void> delete(int id) async {
    if (state is AdvertDeleteLoading) return;

    emit(AdvertDeleteLoading());

    await _repository.delete(id).then((_) {
      emit(AdvertDeleteSuccess());
    }).catchError((Object error) {
      if (error is DioException) {
        emit(AdvertDeleteError(ErrorModel.parseDio(error)));
      } else {
        emit(AdvertDeleteError(ErrorModel.nothing));
      }
    });
  }
}
