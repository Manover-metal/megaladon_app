import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/request/params/register/register_executor_request_params.dart';
import 'package:megaladon/data/repositories/auth/register_repository.dart';

part 'register_executor_event.dart';
part 'register_executor_state.dart';

class RegisterExecutorBloc
    extends Bloc<RegisterExecutorEvent, RegisterExecutorState> {
  // final AuthBloc authBloc;

  RegisterExecutorBloc() : super(RegisterExecutorInitial()) {
    on<RegisterExecutorFetchEvent>(_register);
  }
  final RegisterRepository _repository = RegisterRepository();

  Future<void> _register(RegisterExecutorFetchEvent event, Emitter emit) async {
    if (state is RegisterExecutorLoading) return;

    emit(RegisterExecutorLoading());
    await _repository.registerExecutor(event.params).then((value) {
      emit(RegisterExecutorSuccess(value));
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        emit(RegisterExecutorError(ErrorModel.parseDio(error)));
      } else {
        emit(RegisterExecutorError(ErrorModel.nothing));
      }
    });
  }
}
