part of 'register_executor_bloc.dart';

abstract class RegisterExecutorState extends Equatable {
  const RegisterExecutorState();
}


class RegisterExecutorInitial extends RegisterExecutorState {
  @override
  List<Object> get props => [];
}

class RegisterExecutorSuccess extends RegisterExecutorState {
  @override
  List<Object?> get props => [];
}

class RegisterExecutorLoading extends RegisterExecutorState {
  @override
  List<Object> get props => [];
}

class RegisterExecutorError extends RegisterExecutorState {
  final ErrorModel error;

  RegisterExecutorError(this.error);

  @override
  List<Object> get props => [error];
}