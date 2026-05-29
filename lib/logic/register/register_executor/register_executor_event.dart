part of 'register_executor_bloc.dart';

abstract class RegisterExecutorEvent extends Equatable {
  const RegisterExecutorEvent();
}

class RegisterExecutorFetchEvent extends RegisterExecutorEvent {
  const RegisterExecutorFetchEvent({
    required this.params,
  });
  final RegisterExecutorRequestParams params;

  @override
  List<Object?> get props => [params];
}
