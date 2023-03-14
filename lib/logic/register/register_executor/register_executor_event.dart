part of 'register_executor_bloc.dart';

abstract class RegisterExecutorEvent extends Equatable {
  const RegisterExecutorEvent();
}

class RegisterExecutorFetchEvent extends RegisterExecutorEvent {
  final RegisterExecutorRequestParams params;

  const RegisterExecutorFetchEvent({
    required this.params,
  });

  @override
  List<Object?> get props => [params];

}