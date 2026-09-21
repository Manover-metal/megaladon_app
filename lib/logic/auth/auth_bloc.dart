import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/fb_notification/index.dart';
import 'package:megaladon/core/locale_storage/secure_locale_storage.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/data/repositories/auth/verify_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Зависимости подменяются только в тестах: в приложении блок создаётся
  /// без аргументов и собирает их сам.
  AuthBloc({
    AuthRepository? authRepository,
    VerifyRepository? verifyRepository,
    Future<String?> Function()? fcmTokenReader,
  })  : _authRepository = authRepository ??
            AuthRepository(localeStorage: SecureLocaleStorageImpl()),
        _verifyRepository = verifyRepository ?? VerifyRepository(),
        _fcmTokenReader = fcmTokenReader ?? _defaultFcmTokenReader,
        super(AuthInitial()) {
    on<AuthInitialEvent>(_initial);
    on<AuthLoginEvent>(_login);
    on<AuthVerifyEvent>(_verify);
    on<AuthLogoutEvent>(_logout);

    // Единственный автоматический выход в приложении: бэкенд ответил 401,
    // т.е. токен недействителен. Раньше выход инициировали 17 мест по коду
    // 403, которым бэкенд отвечает и на обычные запреты доступа («не твой
    // заказ», «не участник чата») — из-за этого пользователя выбрасывало
    // из аккаунта на ровном месте, в том числе из фонового опроса чатов.
    _unauthenticatedSub = ApiService.auth.onUnauthenticated
        .listen((_) => add(const AuthLogoutEvent(notifyServer: false)));
  }

  static Future<String?> _defaultFcmTokenReader() =>
      FbNotificationService.I.getToken();

  StreamSubscription<void>? _unauthenticatedSub;
  final AuthRepository _authRepository;
  final VerifyRepository _verifyRepository;
  final Future<String?> Function() _fcmTokenReader;

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
      var token =
          await _fcmTokenReader().timeout(const Duration(seconds: 10));
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

      // Токен шлём именно после write(): /user/change-token требует авторизации,
      // а logout на бэке затирает device_token — без этого вызова после
      // перелогина пуши не приходят до следующего холодного старта.
      _sendFbToken();

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
    if (state is AuthLoadingState) return;
    emit(AuthLoadingState());

    try {
      final auth = await _verifyRepository.verifyRegister(
        code: event.code,
        phone: event.phone,
      );

      // write() ждём: раньше он запускался без await, и если хранилище
      // отказывало (заблокированный keychain), пользователь «входил» без
      // сохранённого токена, а ошибка уходила в никуда.
      await _authRepository.write(auth);

      emit(AuthLoginState(auth));

      // Пуш-токен шлём уже после успеха и без await. FirebaseMessaging
      // .getToken() умеет не возвращаться вовсе — именно на нём подтверждение
      // кода зависало в AuthLoadingState навсегда: ответ 200 приходил,
      // а состояние успеха так и не выставлялось и ошибки не было.
      unawaited(_sendFbToken());
    } on DioException catch (error) {
      print(error);
      emit(AuthErrorState(ErrorModel.parseDio(error)));
    } catch (error) {
      print(error);
      emit(AuthErrorState(ErrorModel.nothing));
    }
  }

  /// Выход уже идёт. Двойное нажатие «Выход» слало два DELETE /auth/logout;
  /// заодно склеиваем одновременные AuthLogoutEvent от ответов 401.
  bool _loggingOut = false;

  Future<void> _logout(AuthLogoutEvent event, Emitter emit) async {
    if (_loggingOut) return;
    _loggingOut = true;
    try {
      await _authRepository.logout(notifyServer: event.notifyServer);
      // AuthLogoutState (а не AuthInitial): отличает «осознанный выход» от
      // «холодного старта». На него реагируют ChatCubit (_dispose),
      // ProfileScreenCubit (notAuth) и навигация в SplashScreen (уход на
      // логин).
      emit(AuthLogoutState());
    } finally {
      _loggingOut = false;
    }
  }

  @override
  Future<void> close() {
    _unauthenticatedSub?.cancel();
    return super.close();
  }
}
