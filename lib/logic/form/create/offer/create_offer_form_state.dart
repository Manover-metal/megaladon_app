part of 'create_offer_form_cubit.dart';

class CreateOfferFormState extends Equatable {
  final bool status;
  final PriceFormModel price;
  final DescriptionFormModel description;
  final CityFormModel city;
  final DateOfferFormModel date;
  final int countTry;
  final EnumFormState formState;
  final ErrorModel? error;
  final int? offerId;

  const CreateOfferFormState({
    this.status = false,
    this.price = const PriceFormModel.pure(),
    this.description = const DescriptionFormModel.pure(),
    this.city = const CityFormModel.pure(),
    this.date = const DateOfferFormModel.pure(),
    this.countTry = 1,
    this.formState = EnumFormState.filled,
    this.error,
    this.offerId
  });

  @override
  List<Object?> get props => [status, price, description, city, countTry, error, offerId, formState];

  CreateOfferFormState copyWith({
    bool? status,
    DescriptionFormModel? description,
    PriceFormModel? price,
    CityFormModel? city,
    int? countTry,
    DateOfferFormModel? date,
    EnumFormState? formState,
    ErrorModel? error,
    int? offerId
  }) {
    return CreateOfferFormState(
        status: status ?? this.status,
        description: description ?? this.description,
        price: price ?? this.price,
        city: city ?? this.city,
        countTry: countTry ?? this.countTry,
        date: date ?? this.date,
        formState: formState ?? this.formState,
        error: error ?? this.error,
        offerId: offerId ?? this.offerId
    );
  }
}

