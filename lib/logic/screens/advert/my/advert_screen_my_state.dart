part of 'advert_screen_my_cubit.dart';

abstract class AdvertScreenMyState extends Equatable {
  final AdvertIndexRequestParams params;

  AdvertScreenMyState({required this.params});
}

class AdvertScreenMyInitial extends AdvertScreenMyState {
  AdvertScreenMyInitial() : super(params: AdvertIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class AdvertScreenMyLoader extends AdvertScreenMyState {
  AdvertScreenMyLoader() : super(params: AdvertIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class AdvertScreenMyError extends AdvertScreenMyState {
  final ErrorModel error;
  AdvertScreenMyError(this.error) : super(params: AdvertIndexRequestParams());

  @override
  List<Object> get props => [error, params];
}

class AdvertScreenMySuccess extends  AdvertScreenMyState {
  final List<AdvertModel> adverts;

  AdvertScreenMySuccess({required this.adverts, required params}): super(params: params);

  @override
  List<Object?> get props => [params, adverts];

  AdvertScreenMySuccess copyWith({
    AdvertIndexRequestParams? params,
    List<AdvertModel>? adverts
  }) {
    return AdvertScreenMySuccess(
        params: params ?? this.params,
        adverts: adverts ?? this.adverts
    );
  }
}
