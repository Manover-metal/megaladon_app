part of 'offer_screen_main_cubit.dart';

abstract class OfferScreenMainState extends Equatable {


}

class OfferScreenMainInitial extends OfferScreenMainState {

  @override
  List<Object> get props => [];
}

class OfferScreenMainLoader extends OfferScreenMainState {

  @override
  List<Object> get props => [];
}

class OfferScreenMainError extends OfferScreenMainState {

  @override
  List<Object> get props => [];
}

class OfferScreenMainSuccess extends  OfferScreenMainState {
  final List<OfferModel> offers;

  OfferScreenMainSuccess({required this.offers}): super();

  @override
  List<Object?> get props => [offers];

  OfferScreenMainSuccess copyWith({
    List<OfferModel>? offers
  }) {
    return OfferScreenMainSuccess(
        offers: offers ?? this.offers
    );
  }
}
