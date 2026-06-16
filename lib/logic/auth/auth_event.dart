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
  @override
  List<Object?> get props => [];
}
