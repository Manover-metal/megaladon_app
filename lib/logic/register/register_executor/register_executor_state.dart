part of 'register_executor_bloc.dart';

abstract class RegisterExecutorState extends Equatable {
  const RegisterExecutorState();
}

class RegisterExecutorInitial extends RegisterExecutorState {
  @override
  List<Object> get props => [];
}

class RegisterExecutorSuccess extends RegisterExecutorState {
  const RegisterExecutorSuccess(this.executor);
  final ExecutorModel executor;

  @override
  List<Object?> get props => [executor];
}

class RegisterExecutorLoading extends RegisterExecutorState {
  @override
  List<Object> get props => [];
}

class RegisterExecutorError extends RegisterExecutorState {
  const RegisterExecutorError(this.error);
  final ErrorModel error;

  @override
  List<Object> get props => [error];
}
