import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/core/fb_notification/index.dart';
import 'package:megaladon/core/locale_storage/secure_locale_storage.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/data/repositories/auth/verify_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthInitialEvent>(_initial);
    on<AuthLoginEvent>(_login);
    on<AuthVerifyEvent>(_verify);
    on<AuthLogoutEvent>(_logout);
  }
  final AuthRepository _authRepository = AuthRepository(
    localeStorage: SecureLocaleStorageImpl(),
  );
  final VerifyRepository _verifyRepository = VerifyRepository();

  Future<void> _initial(AuthInitialEvent event, Emitter emit) async {
    var auth = await _authRepository.read();
    if (auth != null) {
      print(auth.token);
      emit(AuthLoginState(auth));
      _sendFbToken();
    }
  }

  Future _sendFbToken() async {
    try {
      var token = await FbNotificationService.I.getToken();
      if (token != null) {
        _authRepository.sendFB(token: token);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _login(AuthLoginEvent event, Emitter emit) async {
    if (state is AuthLoadingState) return;
    emit(AuthLoadingState());
    await _authRepository
        .login(phone: event.phone, password: event.password)
        .then((value) {
      _authRepository.write(value);

      emit(AuthLoginState(value));
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        if (error.response?.statusCode == 406) {
          emit(AuthTransitionVerify(event.phone));
        } else {
          emit(AuthErrorState(ErrorModel.parseDio(error)));
        }
      } else {
        emit(AuthErrorState(ErrorModel.nothing));
      }
    });
  }

  Future<void> _verify(AuthVerifyEvent event, Emitter emit) async {
    emit(AuthLoadingState());

    await _verifyRepository
        .verifyRegister(code: event.code, phone: event.phone)
        .then((value) async {
      _authRepository.write(value);
      // await _sendFbToken();
      emit(AuthLoginState(value));
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        emit(AuthErrorState(ErrorModel.parseDio(error)));
      } else {
        emit(AuthErrorState(ErrorModel.nothing));
      }
    });
  }

  Future<void> _logout(AuthLogoutEvent event, Emitter emit) async {
    await _authRepository.logout();
    emit(AuthInitial());
  }
}
