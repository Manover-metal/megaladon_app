part of 'advert_screen_details_cubit.dart';

abstract class AdvertScreenDetailsState extends Equatable {}

class AdvertScreenDetailsInitial extends AdvertScreenDetailsState {
  AdvertScreenDetailsInitial();

  @override
  List<Object> get props => [];
}

class AdvertScreenDetailsLoader extends AdvertScreenDetailsState {
  AdvertScreenDetailsLoader();

  @override
  List<Object> get props => [];
}

class AdvertScreenDetailsError extends AdvertScreenDetailsState {
  AdvertScreenDetailsError(this.error);
  final ErrorModel error;

  @override
  List<Object> get props => [error];
}

class AdvertScreenDetailsSuccess extends AdvertScreenDetailsState {
  AdvertScreenDetailsSuccess({required this.advert});
  final AdvertModel advert;

  @override
  List<Object?> get props => [advert];

  AdvertScreenDetailsSuccess copyWith({AdvertModel? advert}) =>
      AdvertScreenDetailsSuccess(advert: advert ?? this.advert);
}
