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
  final ErrorModel error;
  StoreScreenDetailsError(this.error);

  @override
  List<Object> get props => [error];
}

class StoreScreenDetailsSuccess extends  StoreScreenDetailsState {
  final StoreModel store;

  StoreScreenDetailsSuccess({required this.store});

  @override
  List<Object?> get props => [store];

  StoreScreenDetailsSuccess copyWith({
    StoreModel? store
  }) {
    return StoreScreenDetailsSuccess(
        store: store ?? this.store
    );
  }
}
