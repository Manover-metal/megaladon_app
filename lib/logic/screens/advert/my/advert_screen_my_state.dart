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
  final bool stock;

  const AdvertScreenMyState({
    this.status = AdverScreenMyMainStatus.success,
    this.advers = const [],
    this.error,
    this.params = const AdvertIndexRequestParams(),
    this.stock = false
  });

  @override
  List<Object?> get props => [status, advers, error, params, stock];

  AdvertScreenMyState copyWith({
    AdverScreenMyMainStatus? status,
    List<AdvertModel>? advers,
    ErrorModel? error,
    AdvertIndexRequestParams? params,
    bool? stock,
  }) {
    return AdvertScreenMyState(
      status: status ?? this.status,
      advers: advers ?? this.advers,
      error: error,
      params: params ?? this.params,
      stock: stock ?? this.stock
    );
  }
}
