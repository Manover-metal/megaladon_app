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
  final ErrorModel error;
  OfferScreenDetailsError(this.error);

  @override
  List<Object> get props => [error];
}

class OfferScreenDetailsSuccess extends  OfferScreenDetailsState {
  final OfferModel offer;

  OfferScreenDetailsSuccess({required this.offer});

  @override
  List<Object?> get props => [offer];

  OfferScreenDetailsSuccess copyWith({
    OfferModel? offer
  }) {
    return OfferScreenDetailsSuccess(
        offer: offer ?? this.offer
    );
  }
}
