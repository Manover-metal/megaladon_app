part of 'advert_screen_main_cubit.dart';

abstract class AdvertScreenMainState extends Equatable {
  final AdvertIndexRequestParams params;

  AdvertScreenMainState({required this.params});

}

class AdvertScreenMainInitial extends AdvertScreenMainState {
  AdvertScreenMainInitial() : super(params: AdvertIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class AdvertScreenMainLoader extends AdvertScreenMainState {
  AdvertScreenMainLoader() : super(params: AdvertIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class AdvertScreenMainError extends AdvertScreenMainState {
  final ErrorModel error;

  AdvertScreenMainError(this.error) : super(params: AdvertIndexRequestParams());

  @override
  List<Object> get props => [error, params];
}

class AdvertScreenMainSuccess extends  AdvertScreenMainState {
  final List<AdvertModel> adverts;

  AdvertScreenMainSuccess({required this.adverts, required params}): super(params: params);

  @override
  List<Object?> get props => [params, adverts];

  AdvertScreenMainSuccess copyWith({
    AdvertIndexRequestParams? params,
    List<AdvertModel>? adverts
  }) {
    return AdvertScreenMainSuccess(
        params: params ?? this.params,
        adverts: adverts ?? this.adverts
    );
  }
}
