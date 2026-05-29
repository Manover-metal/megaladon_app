part of 'add_favorite_cubit.dart';

abstract class AddFavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddFavoriteInitial extends AddFavoriteState {}

class AddFavoriteLoading extends AddFavoriteState {}

class AddFavoriteSuccess extends AddFavoriteState {}

class AddFavoriteError extends AddFavoriteState {
  AddFavoriteError(this.error);
  final ErrorModel error;

  @override
  List<Object?> get props => [error];
}
