part of 'advert_screen_my_cubit.dart';

enum AdverScreenMyMainStatus {
  loading,
  error,
  success
}

class AdvertScreenMyState extends Equatable {
  final AdverScreenMyMainStatus status;
  final List<AdvertModel> advers;
  final ErrorModel? error;
  final AdvertIndexRequestParams params;

  const AdvertScreenMyState({
    this.status = AdverScreenMyMainStatus.success,
    this.advers = const [],
    this.error,
    this.params =  const AdvertIndexRequestParams()
  });

  @override
  List<Object?> get props => [status, advers, error, params];

  AdvertScreenMyState copyWith({
    AdverScreenMyMainStatus? status,
    List<AdvertModel>? advers,
    ErrorModel? error,
    AdvertIndexRequestParams? params
  }) {
    return AdvertScreenMyState(
      status: status ?? this.status,
      advers: advers ?? this.advers,
      error: error,
      params: params ?? this.params
    );
  }

}


// abstract class AdvertScreenMyState extends Equatable {
//   final AdvertIndexRequestParams params;

//   AdvertScreenMyState({required this.params});
// }

// class AdvertScreenMyInitial extends AdvertScreenMyState {
//   AdvertScreenMyInitial() : super(params: AdvertIndexRequestParams());

//   @override
//   List<Object> get props => [params];
// }

// class AdvertScreenMyLoader extends AdvertScreenMyState {
//   AdvertScreenMyLoader() : super(params: AdvertIndexRequestParams());

//   @override
//   List<Object> get props => [params];
// }

// class AdvertScreenMyError extends AdvertScreenMyState {
//   final ErrorModel error;
//   AdvertScreenMyError(this.error) : super(params: AdvertIndexRequestParams());

//   @override
//   List<Object> get props => [error, params];
// }

// class AdvertScreenMySuccess extends  AdvertScreenMyState {
//   final List<AdvertModel> adverts;

//   AdvertScreenMySuccess({required this.adverts, required params}): super(params: params);

//   @override
//   List<Object?> get props => [params, adverts];

//   AdvertScreenMySuccess copyWith({
//     AdvertIndexRequestParams? params,
//     List<AdvertModel>? adverts
//   }) {
//     return AdvertScreenMySuccess(
//         params: params ?? this.params,
//         adverts: adverts ?? this.adverts
//     );
//   }
// }
