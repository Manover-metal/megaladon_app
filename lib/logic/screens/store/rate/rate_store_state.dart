part of 'rate_store_cubit.dart';

abstract class RateStoreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RateStoreInitial extends RateStoreState {}

class RateStoreLoading extends RateStoreState {}

class RateStoreSuccess extends RateStoreState {}

class RateStoreError extends RateStoreState {
  RateStoreError(this.error);
  final ErrorModel error;

  @override
  List<Object?> get props => [error];
}
