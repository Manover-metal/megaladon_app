part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthInitialEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  const AuthLoginEvent(this.phone, this.password);
  final String phone;
  final String password;

  @override
  List<Object?> get props => [phone, password];
}

class AuthVerifyEvent extends AuthEvent {
  const AuthVerifyEvent(this.phone, this.code);
  final String phone;
  final String code;

  @override
  List<Object?> get props => [phone, code];
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent({this.notifyServer = true});

  /// false — выход не по кнопке, а по 401 от бэкенда: токен уже недействителен,
  /// дёргать DELETE /auth/logout нечем и незачем.
  final bool notifyServer;

  @override
  List<Object?> get props => [notifyServer];
}
