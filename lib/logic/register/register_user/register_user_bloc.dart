import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/register/register_user_request_params.dart';
import 'package:megaladon/data/repositories/auth/register_repository.dart';

part 'register_user_event.dart';
part 'register_user_state.dart';

class RegisterUserBloc extends Bloc<RegisterUserEvent, RegisterUserState> {
  RegisterUserBloc() : super(RegisterUserInitial()) {
    on<RegisterUserFetchEvent>(_register);
  }
  final RegisterRepository _repository = RegisterRepository();

  Future<void> _register(RegisterUserFetchEvent event, Emitter emit) async {
    if (state is RegisterUserLoading) return;

    emit(RegisterUserLoading());
    await _repository.registerUser(event.params).then((value) {
      emit(RegisterUserSuccess());
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        emit(RegisterUserError(ErrorModel.parseDio(error)));
      } else {
        emit(RegisterUserError(ErrorModel.nothing));
      }
    });
  }
}
