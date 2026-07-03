part of 'executor_reviews_cubit.dart';

enum ExecutorReviewsStatus { loading, error, success }

class ExecutorReviewsState extends Equatable {
  const ExecutorReviewsState({
    this.status = ExecutorReviewsStatus.loading,
    this.reviews = const [],
    this.error,
  });

  final ExecutorReviewsStatus status;
  final List<ReviewModel> reviews;
  final ErrorModel? error;

  @override
  List<Object?> get props => [status, reviews, error];

  ExecutorReviewsState copyWith({
    ExecutorReviewsStatus? status,
    List<ReviewModel>? reviews,
    ErrorModel? error,
  }) =>
      ExecutorReviewsState(
        status: status ?? this.status,
        reviews: reviews ?? this.reviews,
        error: error,
      );
}
