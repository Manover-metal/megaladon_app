import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/repositories/register_repository.dart';

part 'register_user_event.dart';
part 'register_user_state.dart';

class RegisterUserBloc extends Bloc<RegisterUserEvent, RegisterUserState> {
  final RegisterRepository _repository = RegisterRepository();
  RegisterUserBloc() : super(RegisterUserInitial()) {
    on<RegisterUserFetchEvent>(_register);
  }

  _register(RegisterUserFetchEvent event, Emitter emit ) async {
    emit(RegisterUserLoading());
    await _repository.registerUser(
        name: event.name,
        phone: event.phone,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        cityId: 1
    ).then((value) {
      emit(RegisterUserSuccess());
    }).catchError((error) {
      emit(RegisterUserError(error.response.data['message']));
    });
  }
}
