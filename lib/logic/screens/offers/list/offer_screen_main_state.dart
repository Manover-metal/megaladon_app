part of 'offer_screen_main_cubit.dart';

abstract class OfferScreenMainState extends Equatable {}

class OfferScreenMainInitial extends OfferScreenMainState {
  @override
  List<Object> get props => [];
}

class OfferScreenMainLoader extends OfferScreenMainState {
  @override
  List<Object> get props => [];
}

class OfferScreenMainError extends OfferScreenMainState {
  OfferScreenMainError(this.error);
  final ErrorModel error;

  @override
  List<Object> get props => [error];
}

class OfferScreenMainSuccess extends OfferScreenMainState {
  OfferScreenMainSuccess({required this.offers}) : super();
  final List<OfferModel> offers;

  @override
  List<Object?> get props => [offers];

  OfferScreenMainSuccess copyWith({List<OfferModel>? offers}) =>
      OfferScreenMainSuccess(offers: offers ?? this.offers);
}
