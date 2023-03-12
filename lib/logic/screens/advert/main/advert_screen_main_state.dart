part of 'advert_screen_main_cubit.dart';


enum AdverScreenMainStatus {
  loading,
  error,
  success
}

class AdvertScreenMainState extends Equatable {
  final AdverScreenMainStatus status;
  final List<AdvertModel> advers;
  final ErrorModel? error;
  final AdvertIndexRequestParams params;

  const AdvertScreenMainState({
    this.status = AdverScreenMainStatus.success,
    this.advers = const [],
    this.error,
    this.params =  const AdvertIndexRequestParams()
  });

  @override
  List<Object?> get props => [status, advers, error, params];

  AdvertScreenMainState copyWith({
    AdverScreenMainStatus? status,
    List<AdvertModel>? advers,
    ErrorModel? error,
    AdvertIndexRequestParams? params
  }) {
    return AdvertScreenMainState(
      status: status ?? this.status,
      advers: advers ?? this.advers,
      error: error,
      params: params ?? this.params
    );
  }

}

// abstract class AdvertScreenMainState extends Equatable {
//   final AdvertIndexRequestParams params;

//   AdvertScreenMainState({required this.params});

// }

// class AdvertScreenMainInitial extends AdvertScreenMainState {
//   AdvertScreenMainInitial() : super(params: AdvertIndexRequestParams());

//   @override
//   List<Object> get props => [params];
// }

// class AdvertScreenMainLoader extends AdvertScreenMainState {
//   AdvertScreenMainLoader() : super(params: AdvertIndexRequestParams());

//   @override
//   List<Object> get props => [params];
// }

// class AdvertScreenMainError extends AdvertScreenMainState {
//   final ErrorModel error;

//   AdvertScreenMainError(this.error) : super(params: AdvertIndexRequestParams());

//   @override
//   List<Object> get props => [error, params];
// }

// class AdvertScreenMainSuccess extends  AdvertScreenMainState {
//   final List<AdvertModel> adverts;

//   AdvertScreenMainSuccess({required this.adverts, required params}): super(params: params);

//   @override
//   List<Object?> get props => [params, adverts];

//   AdvertScreenMainSuccess copyWith({
//     AdvertIndexRequestParams? params,
//     List<AdvertModel>? adverts
//   }) {
//     return AdvertScreenMainSuccess(
//         params: params ?? this.params,
//         adverts: adverts ?? this.adverts
//     );
//   }
// }
