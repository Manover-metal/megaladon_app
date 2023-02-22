part of 'store_screen_main_cubit.dart';

abstract class StoreScreenMainState extends Equatable {
  final StoreIndexRequestParams params;

  StoreScreenMainState({required this.params});

}

class StoreScreenMainInitial extends StoreScreenMainState {
  StoreScreenMainInitial() : super(params: StoreIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class StoreScreenMainLoader extends StoreScreenMainState {
  StoreScreenMainLoader() : super(params: StoreIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class StoreScreenMainError extends StoreScreenMainState {
  StoreScreenMainError() : super(params: StoreIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class StoreScreenMainSuccess extends  StoreScreenMainState {
  final List<StoreModel> stores;

  StoreScreenMainSuccess({required this.stores, required params}): super(params: params);

  @override
  List<Object?> get props => [params, stores];

  StoreScreenMainSuccess copyWith({
    StoreIndexRequestParams? params,
    List<StoreModel>? stores
  }) {
    return StoreScreenMainSuccess(
        params: params ?? this.params,
        stores: stores ?? this.stores
    );
  }
}
