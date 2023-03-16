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
  final bool stock;

  const AdvertScreenMainState({
    this.status = AdverScreenMainStatus.success,
    this.advers = const [],
    this.error,
    this.params = const AdvertIndexRequestParams(),
    this.stock = false
  });

  @override
  List<Object?> get props => [status, advers, error, params, stock];

  AdvertScreenMainState copyWith({
    AdverScreenMainStatus? status,
    List<AdvertModel>? advers,
    ErrorModel? error,
    AdvertIndexRequestParams? params,
    bool? stock
  }) {
    return AdvertScreenMainState(
      status: status ?? this.status,
      advers: advers ?? this.advers,
      error: error,
      params: params ?? this.params,
      stock: stock ?? this.stock
    );
  }

}