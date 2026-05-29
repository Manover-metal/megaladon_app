part of 'change_executor_bloc.dart';

abstract class ChangeExecutorEvent extends Equatable {
  const ChangeExecutorEvent();
}

class ChangeExecutorFetchEvent extends ChangeExecutorEvent {
  const ChangeExecutorFetchEvent({
    required this.params,
  });
  final ChangeExecutorRequestParams params;

  @override
  List<Object?> get props => [params];
}
