
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/request/params/register/register_executor_request_params.dart';
import 'package:megaladon/data/repositories/auth/register_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'register_executor_event.dart';
part 'register_executor_state.dart';

class RegisterExecutorBloc extends Bloc<RegisterExecutorEvent, RegisterExecutorState> {
  final RegisterRepository _repository = RegisterRepository();
  // final AuthBloc authBloc;

  RegisterExecutorBloc() : super(RegisterExecutorInitial()) {
    on<RegisterExecutorFetchEvent>(_register);
  }

  _register(RegisterExecutorFetchEvent event, Emitter emit ) async {
    if(state is RegisterExecutorLoading) return;

    emit(RegisterExecutorLoading());
    await _repository.registerExecutor(event.params).then((value) {
      final ExecutorModel executor = ExecutorModel.fromJson(value.data['executor']);
      emit(RegisterExecutorSuccess(executor));
    }).catchError((error) {
      if(error is DioError) {
        emit(RegisterExecutorError(ErrorModel.parseDio(error)));
      } else {
        emit(RegisterExecutorError(ErrorModel.nothing));
      }
    });
  }
}
