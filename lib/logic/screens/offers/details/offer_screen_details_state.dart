part of 'offer_screen_details_cubit.dart';

abstract class OfferScreenDetailsState extends Equatable {}

class OfferScreenDetailsInitial extends OfferScreenDetailsState {
  OfferScreenDetailsInitial();

  @override
  List<Object> get props => [];
}

class OfferScreenDetailsLoader extends OfferScreenDetailsState {
  OfferScreenDetailsLoader();

  @override
  List<Object> get props => [];
}

class OfferScreenDetailsError extends OfferScreenDetailsState {
  OfferScreenDetailsError(this.error);
  final ErrorModel error;

  @override
  List<Object> get props => [error];
}

class OfferScreenDetailsSuccess extends OfferScreenDetailsState {
  OfferScreenDetailsSuccess({required this.offer});
  final OfferModel offer;

  @override
  List<Object?> get props => [offer];

  OfferScreenDetailsSuccess copyWith({OfferModel? offer}) =>
      OfferScreenDetailsSuccess(offer: offer ?? this.offer);
}
