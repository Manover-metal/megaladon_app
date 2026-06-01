part of 'review_cubit.dart';

abstract class ReviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {}

class ReviewError extends ReviewState {
  ReviewError(this.error);
  final ErrorModel error;

  @override
  List<Object?> get props => [error];
}
