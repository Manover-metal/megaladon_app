part of 'store_screen_details_cubit.dart';

abstract class StoreScreenDetailsState extends Equatable {}

class StoreScreenDetailsInitial extends StoreScreenDetailsState {
  StoreScreenDetailsInitial();

  @override
  List<Object> get props => [];
}

class StoreScreenDetailsLoader extends StoreScreenDetailsState {
  StoreScreenDetailsLoader();

  @override
  List<Object> get props => [];
}

class StoreScreenDetailsError extends StoreScreenDetailsState {
  StoreScreenDetailsError(this.error);
  final ErrorModel error;

  @override
  List<Object> get props => [error];
}

class StoreScreenDetailsSuccess extends StoreScreenDetailsState {
  StoreScreenDetailsSuccess({required this.store});
  final StoreModel store;

  @override
  List<Object?> get props => [store];

  StoreScreenDetailsSuccess copyWith({StoreModel? store}) =>
      StoreScreenDetailsSuccess(store: store ?? this.store);
}
