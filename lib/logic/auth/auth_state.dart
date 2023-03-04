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

  AuthTransitionVerify(this.phone);

  @override
  // TODO: implement props
  List<Object?> get props => [this.phone];

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


class AuthLogoutEventState extends AuthState {
  @override
  List<Object?> get props => [];
}