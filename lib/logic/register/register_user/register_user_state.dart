part of 'register_user_bloc.dart';

abstract class RegisterUserState extends Equatable {
  const RegisterUserState();
}

class RegisterUserInitial extends RegisterUserState {
  @override
  List<Object> get props => [];
}

class RegisterUserSuccess extends RegisterUserState {
  @override
  List<Object?> get props => [];
}

class RegisterUserLoading extends RegisterUserState {
  @override
  List<Object> get props => [];
}

class RegisterUserError extends RegisterUserState {
  final ErrorModel error;

  RegisterUserError(this.error);

  @override
  List<Object> get props => [error];
}

