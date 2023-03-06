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
  final ErrorModel error;

  AdvertScreenDetailsError(this.error);

  @override
  List<Object> get props => [error];
}

class AdvertScreenDetailsSuccess extends  AdvertScreenDetailsState {
  final AdvertModel advert;

  AdvertScreenDetailsSuccess({required this.advert});

  @override
  List<Object?> get props => [advert];

  AdvertScreenDetailsSuccess copyWith({
    AdvertModel? advert
  }) {
    return AdvertScreenDetailsSuccess(
        advert: advert ?? this.advert
    );
  }
}
