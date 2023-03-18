import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/repositories/executor_repository.dart';

part 'executor_screen_my_state.dart';

class ExecutorScreenMyCubit extends Cubit<ExecutorScreenMyState> {
  final ExecutorRepository _repository = ExecutorRepository();
  ExecutorScreenMyCubit() : super(const ExecutorScreenMyState());

  Future fetch() async {
    if(state.status == ExecutorScreenMyStatus.loading
        && state.error == null
    ) return;

    emit(state.copyWith(
        status: ExecutorScreenMyStatus.loading,
        error: null,
        executors: state.executors,

      )
    );

    return await _repository.my().then((value) {
      emit(state.copyWith(
          status: ExecutorScreenMyStatus.success,
          executors: [...state.executors, ...value],
      ));
    }).catchError(( error) {
      if(error is DioError) {
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }
}