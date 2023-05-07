part of 'change_executor_bloc.dart';

abstract class ChangeExecutorEvent extends Equatable {
  const ChangeExecutorEvent();
}

class ChangeExecutorFetchEvent extends ChangeExecutorEvent {
  final ChangeExecutorRequestParams params;

  const ChangeExecutorFetchEvent({
    required this.params,
  });

  @override
  List<Object?> get props => [params];

}