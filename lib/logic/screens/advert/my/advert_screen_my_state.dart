part of 'advert_screen_my_cubit.dart';

enum AdverScreenMyMainStatus { loading, error, success }

class AdvertScreenMyState extends Equatable {
  const AdvertScreenMyState({
    this.status = AdverScreenMyMainStatus.success,
    this.adverts = const [],
    this.error,
    this.params = const AdvertIndexRequestParams(),
    this.stock = false,
  });

  final AdverScreenMyMainStatus status;
  final List<AdvertModel> adverts;
  final ErrorModel? error;
  final AdvertIndexRequestParams params;
  final bool stock;

  @override
  List<Object?> get props => [status, adverts, error, params, stock];

  AdvertScreenMyState copyWith({
    AdverScreenMyMainStatus? status,
    List<AdvertModel>? adverts,
    ErrorModel? error,
    AdvertIndexRequestParams? params,
    bool? stock,
  }) =>
      AdvertScreenMyState(
        status: status ?? this.status,
        adverts: adverts ?? this.adverts,
        error: error,
        params: params ?? this.params,
        stock: stock ?? this.stock,
      );
}
