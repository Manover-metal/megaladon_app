import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/repositories/executor_repository.dart';

part 'executor_screen_details_state.dart';

class ExecutorScreenDetailsCubit extends Cubit<ExecutorScreenDetailsState> {
  ExecutorScreenDetailsCubit() : super(ExecutorScreenDetailsInitial());
  final ExecutorRepository _repository = ExecutorRepository();

  Future<void> fetch({required int executorId}) async {
    if (state is ExecutorScreenDetailsSuccess) {
      if ((state as ExecutorScreenDetailsSuccess).executor.id == executorId)
        return;
    }
    emit(ExecutorScreenDetailsLoader());
    return await _fetch(id: executorId);
  }

  Future<void> _fetch({required int id}) async {
    emit(ExecutorScreenDetailsLoader());
    await _repository.getById(id).then((value) {
      emit(ExecutorScreenDetailsSuccess(executor: value));
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        emit(ExecutorScreenDetailsError(ErrorModel.parseDio(error)));
      } else {
        emit(ExecutorScreenDetailsError(ErrorModel.nothing));
      }
    });
  }
}
