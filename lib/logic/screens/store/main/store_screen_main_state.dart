part of 'store_screen_main_cubit.dart';

enum StoreScreenMainStatus {
  loading,
  error,
  success
}

class StoreScreenMainState extends Equatable {
  final StoreScreenMainStatus status;
  final List<StoreModel> stores;
  final ErrorModel? error;
  final StoreIndexRequestParams params;

  const StoreScreenMainState({
    this.status = StoreScreenMainStatus.success,
    this.stores = const [],
    this.error,
    this.params =  const StoreIndexRequestParams()
  });

  @override
  List<Object?> get props => [status, stores, error, params];

  StoreScreenMainState copyWith({
    StoreScreenMainStatus? status,
    List<StoreModel>? stores,
    ErrorModel? error,
    StoreIndexRequestParams? params
  }) {
    return StoreScreenMainState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      error: error,
      params: params ?? this.params
    );
  }

}

// abstract class StoreScreenMainState extends Equatable {
//   final StoreIndexRequestParams params;

//   StoreScreenMainState({required this.params});

// }

// class StoreScreenMainInitial extends StoreScreenMainState {
//   StoreScreenMainInitial() : super(params: StoreIndexRequestParams());

//   @override
//   List<Object> get props => [params];
// }

// class StoreScreenMainLoader extends StoreScreenMainState {
//   StoreScreenMainLoader() : super(params: StoreIndexRequestParams());

//   @override
//   List<Object> get props => [params];
// }

// class StoreScreenMainError extends StoreScreenMainState {
//   final ErrorModel error;
//   StoreScreenMainError(this.error) : super(params: StoreIndexRequestParams());

//   @override
//   List<Object> get props => [error, params];
// }

// class StoreScreenMainSuccess extends  StoreScreenMainState {
//   final List<StoreModel> stores;

//   StoreScreenMainSuccess({required this.stores, required params}): super(params: params);

//   @override
//   List<Object?> get props => [params, stores];

//   StoreScreenMainSuccess copyWith({
//     StoreIndexRequestParams? params,
//     List<StoreModel>? stores
//   }) {
//     return StoreScreenMainSuccess(
//         params: params ?? this.params,
//         stores: stores ?? this.stores
//     );
//   }
// }
