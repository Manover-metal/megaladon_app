part of 'advert_screen_main_cubit.dart';

enum AdverScreenMainStatus { loading, error, success }

class AdvertScreenMainState extends Equatable {
  const AdvertScreenMainState(
      {this.status = AdverScreenMainStatus.success,
      this.adverts = const [],
      this.error,
      this.params = const AdvertIndexRequestParams(),
      this.stock = false});
  final AdverScreenMainStatus status;
  final List<AdvertModel> adverts;

  final ErrorModel? error;
  final AdvertIndexRequestParams params;
  final bool stock;

  @override
  List<Object?> get props => [status, adverts, error, params, stock];

  AdvertScreenMainState copyWith(
          {AdverScreenMainStatus? status,
          List<AdvertModel>? adverts,
          ErrorModel? error,
          AdvertIndexRequestParams? params,
          bool? stock}) =>
      AdvertScreenMainState(
          status: status ?? this.status,
          adverts: adverts ?? this.adverts,
          error: error,
          params: params ?? this.params,
          stock: stock ?? this.stock);
}
