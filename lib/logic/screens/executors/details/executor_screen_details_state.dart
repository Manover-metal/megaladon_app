part of 'executor_screen_details_cubit.dart';

abstract class ExecutorScreenDetailsState extends Equatable {}

class ExecutorScreenDetailsInitial extends ExecutorScreenDetailsState {
  ExecutorScreenDetailsInitial();

  @override
  List<Object> get props => [];
}

class ExecutorScreenDetailsLoader extends ExecutorScreenDetailsState {
  ExecutorScreenDetailsLoader();

  @override
  List<Object> get props => [];
}

class ExecutorScreenDetailsError extends ExecutorScreenDetailsState {
  final ErrorModel error;
  ExecutorScreenDetailsError(this.error);

  @override
  List<Object> get props => [error];
}

class ExecutorScreenDetailsSuccess extends  ExecutorScreenDetailsState {
  final ExecutorModel executor;

  ExecutorScreenDetailsSuccess({required this.executor});

  @override
  List<Object?> get props => [executor];

  ExecutorScreenDetailsSuccess copyWith({
    ExecutorModel? executor
  }) {
    return ExecutorScreenDetailsSuccess(
        executor: executor ?? this.executor
    );
  }
}
