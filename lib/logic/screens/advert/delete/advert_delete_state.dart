part of 'advert_delete_cubit.dart';

abstract class AdvertDeleteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdvertDeleteInitial extends AdvertDeleteState {}

class AdvertDeleteLoading extends AdvertDeleteState {}

class AdvertDeleteSuccess extends AdvertDeleteState {}

class AdvertDeleteError extends AdvertDeleteState {
  AdvertDeleteError(this.error);
  final ErrorModel error;

  @override
  List<Object?> get props => [error];
}
