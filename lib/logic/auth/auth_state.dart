part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final bool isAuth;
  const AuthState({this.isAuth = false});
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoginState extends AuthState {
  final AuthModel auth;


  const AuthLoginState(this.auth): super(isAuth: true);

  @override
  List<Object?> get props => [auth];
}

class AuthTransitionVerify extends AuthState {
  final String phone;

  const AuthTransitionVerify(this.phone);

  @override
  List<Object?> get props => [phone];

}


class AuthErrorState extends AuthState {
  final ErrorModel error;

  const AuthErrorState(this.error);

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