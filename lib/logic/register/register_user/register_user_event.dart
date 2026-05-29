part of 'register_user_bloc.dart';

abstract class RegisterUserEvent extends Equatable {
  const RegisterUserEvent();
}

class RegisterUserFetchEvent extends RegisterUserEvent {
  const RegisterUserFetchEvent(this.params);
  final RegisterUserRequestParams params;

  @override
  List<Object?> get props => [params];
}
