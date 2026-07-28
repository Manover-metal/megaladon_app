part of 'user_reviews_cubit.dart';

enum UserReviewsStatus { loading, error, success }

class UserReviewsState extends Equatable {
  const UserReviewsState({
    this.status = UserReviewsStatus.loading,
    this.reviews = const [],
    this.error,
  });

  final UserReviewsStatus status;
  final List<ReviewModel> reviews;
  final ErrorModel? error;

  @override
  List<Object?> get props => [status, reviews, error];

  UserReviewsState copyWith({
    UserReviewsStatus? status,
    List<ReviewModel>? reviews,
    ErrorModel? error,
  }) =>
      UserReviewsState(
        status: status ?? this.status,
        reviews: reviews ?? this.reviews,
        error: error,
      );
}
