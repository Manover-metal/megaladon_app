part of 'service_screen_my_cubit.dart';

enum ServiceScreenMyStatus { loading, error, success }

class ServiceScreenMyState extends Equatable {
  const ServiceScreenMyState({
    this.status = ServiceScreenMyStatus.success,
    this.services = const [],
    this.error,
    this.params = const AdvertIndexRequestParams(),
    this.stock = false,
  });

  final ServiceScreenMyStatus status;
  final List<AdvertModel> services;
  final ErrorModel? error;
  final AdvertIndexRequestParams params;
  final bool stock;

  @override
  List<Object?> get props => [status, services, error, params, stock];

  ServiceScreenMyState copyWith({
    ServiceScreenMyStatus? status,
    List<AdvertModel>? services,
    ErrorModel? error,
    AdvertIndexRequestParams? params,
    bool? stock,
  }) =>
      ServiceScreenMyState(
        status: status ?? this.status,
        services: services ?? this.services,
        error: error,
        params: params ?? this.params,
        stock: stock ?? this.stock,
      );
}
