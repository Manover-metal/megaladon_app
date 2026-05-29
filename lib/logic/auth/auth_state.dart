part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState({this.isAuth = false});
  final bool isAuth;
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoginState extends AuthState {
  const AuthLoginState(this.auth) : super(isAuth: true);
  final AuthModel auth;

  @override
  List<Object?> get props => [auth];
}

class AuthTransitionVerify extends AuthState {
  const AuthTransitionVerify(this.phone);
  final String phone;

  @override
  List<Object?> get props => [phone];
}

class AuthErrorState extends AuthState {
  const AuthErrorState(this.error);
  final ErrorModel error;

  @override
  List<Object?> get props => [error];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLogoutState extends AuthState {
  @override
  List<Object?> get props => [];
}
