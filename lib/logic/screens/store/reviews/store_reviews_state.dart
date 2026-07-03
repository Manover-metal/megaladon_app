part of 'store_reviews_cubit.dart';

enum StoreReviewsStatus { loading, error, success }

class StoreReviewsState extends Equatable {
  const StoreReviewsState({
    this.status = StoreReviewsStatus.loading,
    this.reviews = const [],
    this.error,
  });

  final StoreReviewsStatus status;
  final List<ReviewModel> reviews;
  final ErrorModel? error;

  @override
  List<Object?> get props => [status, reviews, error];

  StoreReviewsState copyWith({
    StoreReviewsStatus? status,
    List<ReviewModel>? reviews,
    ErrorModel? error,
  }) =>
      StoreReviewsState(
        status: status ?? this.status,
        reviews: reviews ?? this.reviews,
        error: error,
      );
}
