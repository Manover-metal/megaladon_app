import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/dio/interceptors/auth_interceptors.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/data/repositories/auth/verify_repository.dart';
import 'package:megaladon/logic/register/register_executor/register_executor_bloc.dart';
import 'package:megaladon/logic/register/register_store/register_store_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  final VerifyRepository _verifyRepository = VerifyRepository();
  final RegisterStoreBloc registerStoreBloc;
  final RegisterExecutorBloc registerExecutorBloc;


  AuthBloc(this.registerStoreBloc, this.registerExecutorBloc) : super(AuthInitial()) {
    on<AuthInitialEvent>(_initial);
    on<AuthLoginEvent>(_login);
    on<AuthVerifyEvent>(_verify);
    on<AuthLogoutEvent>(_logout);
    registerExecutorBloc.stream.listen(_listenRegisterExecutor);
    registerStoreBloc.stream.listen(_listenRegisterStore);
  }

  _initial(AuthInitialEvent event, Emitter emit) async {
    AuthModel? auth = await _authRepository.read();
    print(auth?.token);
    if(auth != null) {
      emit(AuthLoginState(auth));
    }
  }

  _login(AuthLoginEvent event, Emitter emit) async {
    emit(AuthLoadingState());
    await _authRepository.login(phone: event.phone, password: event.password).then((value) {

      final user = UserModel.fromJson(value.data['user']);
      final executor = value.data['user']['executor'] != null? ExecutorModel.fromJson(value.data['user']['executor']): null;
      final store = value.data['user']['store'] != null? StoreModel.fromJsonFull(value.data['user']['store']): null;


      AuthModel auth = AuthModel()
        ..token = value.data['token']
        ..user.value = user
        ..executor.value = executor
        ..store.value = store;

      _authRepository.write(auth, user, executor, store);

      emit(AuthLoginState(auth));
    }).catchError((error) {
      print(error);

      if(error is DioError) {
        if(error.response?.statusCode == 406) {
          emit(AuthTransitionVerify(event.phone));
        } else {
          emit(AuthErrorState(error.response?.data['message']));
        }
      } else {
        emit(AuthErrorState('Произошла ошибка'));
      }

    });
  }

  _verify(AuthVerifyEvent event, Emitter emit) async {
    emit(AuthLoadingState());

    await _verifyRepository.verifyRegister(code: event.code, phone: event.phone).then((value) {

      final user = UserModel.fromJson(value.data['user']);
      final executor = value.data['user']['executor'] != null? ExecutorModel.fromJson(value.data['user']['executor']): null;
      final store = value.data['user']['store'] != null? StoreModel.fromJsonFull(value.data['user']['store']): null;

      AuthModel auth = AuthModel()
        ..token = value.data['token']
        ..user.value = user
        ..executor.value = executor
        ..store.value = store;

      _authRepository.write(auth, user, executor, store);

      emit(AuthLoginState(auth));
    }).catchError((error) {
      print(error);
      if(error is DioError) {
        emit(AuthErrorState(error.response?.data['message']));
      } else {
        emit(AuthErrorState('Произошла ошибка'));
      }

    });
  }

  _logout(AuthLogoutEvent event, Emitter emit) async {
    await _authRepository.logout();
    emit(AuthInitial());
  }

  _listenRegisterExecutor(RegisterExecutorState stateRegister) async {
    if(stateRegister is RegisterExecutorSuccess && state is AuthLoginState) {
      final AuthLoginState currentState = state as AuthLoginState;
      final AuthModel auth = currentState.auth;
      auth.executor.value = stateRegister.executor;
      await _authRepository.addExecutor(auth, stateRegister.executor);
      emit(AuthLoginState(auth));
    }
  }

  _listenRegisterStore(RegisterStoreState stateStore) async {
    if(stateStore is RegisterStoreSuccess && state is AuthLoginState) {
      final AuthLoginState currentState = state as AuthLoginState;
      final AuthModel auth = currentState.auth;
      auth.store.value = stateStore.store;
      await _authRepository.addStore(auth, stateStore.store);
      emit(AuthLoginState(auth));
    }
  }
}
