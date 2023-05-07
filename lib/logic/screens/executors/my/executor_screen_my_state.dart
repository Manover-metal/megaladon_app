part of 'executor_screen_my_cubit.dart';


enum ExecutorScreenMyStatus {
  loading,
  error,
  success
}

class ExecutorScreenMyState extends Equatable {
  final ExecutorScreenMyStatus status;
  final List<ExecutorModel> executors;
  final ErrorModel? error;

  const ExecutorScreenMyState({
    this.status = ExecutorScreenMyStatus.success,
    this.executors = const [],
    this.error
  });

  @override
  List<Object?> get props => [status, executors, error];

  ExecutorScreenMyState copyWith({
    ExecutorScreenMyStatus? status,
    List<ExecutorModel>? executors,
    ErrorModel? error,
  }) {
    return ExecutorScreenMyState(
      status: status ?? this.status,
      executors: executors ?? this.executors,
      error: error,
    );
  }

}