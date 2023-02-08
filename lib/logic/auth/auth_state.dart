part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoginState extends AuthState {
  final AuthModel auth;

  const AuthLoginState(this.auth);

  @override
  List<Object?> get props => [auth];
}

class AuthErrorState extends AuthState {
  final String error;

  const AuthErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}