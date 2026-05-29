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
  ExecutorScreenDetailsError(this.error);
  final ErrorModel error;

  @override
  List<Object> get props => [error];
}

class ExecutorScreenDetailsSuccess extends ExecutorScreenDetailsState {
  ExecutorScreenDetailsSuccess({required this.executor});
  final ExecutorModel executor;

  @override
  List<Object?> get props => [executor];

  ExecutorScreenDetailsSuccess copyWith({ExecutorModel? executor}) =>
      ExecutorScreenDetailsSuccess(executor: executor ?? this.executor);
}
