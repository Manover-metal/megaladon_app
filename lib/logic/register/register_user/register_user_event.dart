part of 'register_user_bloc.dart';

abstract class RegisterUserEvent extends Equatable {
  const RegisterUserEvent();
}

class RegisterUserFetchEvent extends RegisterUserEvent {
  final RegisterUserRequestParams params;

  const RegisterUserFetchEvent(this.params);

  @override
  List<Object?> get props => [params];

}