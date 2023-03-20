part of 'change_executor_bloc.dart';

abstract class ChangeExecutorState extends Equatable {
  const ChangeExecutorState();
}


class ChangeExecutorInitial extends ChangeExecutorState {
  @override
  List<Object> get props => [];
}

class ChangeExecutorSuccess extends ChangeExecutorState {

  @override
  List<Object?> get props => [];
}

class ChangeExecutorLoading extends ChangeExecutorState {
  @override
  List<Object> get props => [];
}

class ChangeExecutorError extends ChangeExecutorState {
  final ErrorModel error;

  const ChangeExecutorError(this.error);

  @override
  List<Object> get props => [error];
}