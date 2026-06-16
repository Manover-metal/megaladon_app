part of 'service_screen_main_cubit.dart';

enum ServiceScreenMainStatus { loading, error, success }

class ServiceScreenMainState extends Equatable {
  const ServiceScreenMainState(
      {this.status = ServiceScreenMainStatus.success,
      this.services = const [],
      this.error,
      this.params = const AdvertIndexRequestParams(),
      this.stock = false});
  final ServiceScreenMainStatus status;
  final List<AdvertModel> services;

  final ErrorModel? error;
  final AdvertIndexRequestParams params;
  final bool stock;

  @override
  List<Object?> get props => [status, services, error, params, stock];

  ServiceScreenMainState copyWith(
          {ServiceScreenMainStatus? status,
          List<AdvertModel>? services,
          ErrorModel? error,
          AdvertIndexRequestParams? params,
          bool? stock}) =>
      ServiceScreenMainState(
          status: status ?? this.status,
          services: services ?? this.services,
          error: error,
          params: params ?? this.params,
          stock: stock ?? this.stock);
}
