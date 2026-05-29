part of 'advert_screen_main_cubit.dart';

enum AdverScreenMainStatus { loading, error, success }

class AdvertScreenMainState extends Equatable {
  const AdvertScreenMainState(
      {this.status = AdverScreenMainStatus.success,
      this.adverts = const [],
      this.services = const [],
      this.error,
      this.params = const AdvertIndexRequestParams(),
      this.stock = false});
  final AdverScreenMainStatus status;
  final List<AdvertModel> adverts;
  final List<AdvertModel> services;

  final ErrorModel? error;
  final AdvertIndexRequestParams params;
  final bool stock;

  @override
  List<Object?> get props => [status, adverts, services, error, params, stock];

  AdvertScreenMainState copyWith(
          {AdverScreenMainStatus? status,
          List<AdvertModel>? adverts,
          List<AdvertModel>? services,
          ErrorModel? error,
          AdvertIndexRequestParams? params,
          bool? stock}) =>
      AdvertScreenMainState(
          status: status ?? this.status,
          adverts: adverts ?? this.adverts,
          services: services ?? this.services,
          error: error,
          params: params ?? this.params,
          stock: stock ?? this.stock);
}
