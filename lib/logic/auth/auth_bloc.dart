import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/auth_model.dart';
import 'package:megaladon/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository = AuthRepository();
  AuthBloc() : super(AuthInitial()) {
    on<AuthInitialEvent>(_initial);
    on<AuthLoginEvent>(_login);
  }

  _initial(AuthInitialEvent event, Emitter emit) async {
    AuthModel? auth = await _repository.read();
    if(auth != null) {
      emit(AuthLoginState(auth));
    }
  }

  _login(AuthLoginEvent event, Emitter emit) async {
    emit(AuthLoadingState());
    await _repository.login(phone: event.phone, password: event.password).then((value) {
      print(value);
      // emit(AuthLoginState(auth));
    }).catchError((error){
      print(error.response.data['message']);
      emit(AuthErrorState(error.response.data['message']));
    });
  }
}
