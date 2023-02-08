part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthInitialEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final String phone;
  final String password;

  const AuthLoginEvent(this.phone, this.password);

  @override
  List<Object?> get props => [phone, password];

}