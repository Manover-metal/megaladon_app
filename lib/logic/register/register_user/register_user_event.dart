part of 'register_user_bloc.dart';

abstract class RegisterUserEvent extends Equatable {
  const RegisterUserEvent();
}

class RegisterUserFetchEvent extends RegisterUserEvent {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;

  RegisterUserFetchEvent(this.name, this.phone, this.password, this.passwordConfirmation);

  @override
  List<Object?> get props => [name, phone, password, passwordConfirmation];

}