part of 'create_offer_form_cubit.dart';

class CreateOfferFormState extends Equatable {
  final bool status;
  final PriceFormModel price;
  final DescriptionFormModel description;
  final CityFormModel city;
  final ExpiredAtFormModel expiredAt;
  final DateOfferFormModel date;
  final int countTry;
  final EnumFormState formState;

  const CreateOfferFormState({
    this.status = false,
    this.price = const PriceFormModel.pure(),
    this.description = const DescriptionFormModel.pure(),
    this.city = const CityFormModel.pure(),
    this.expiredAt = const ExpiredAtFormModel.pure(),
    this.date = const DateOfferFormModel.pure(),
    this.countTry = 1,
    this.formState = EnumFormState.filled
  });

  @override
  List<Object?> get props => [status, price, description, city, countTry];

  CreateOfferFormState copyWith({
    bool? status,
    DescriptionFormModel? description,
    PriceFormModel? price,
    CityFormModel? city,
    int? countTry,
    ExpiredAtFormModel? expiredAt,
    DateOfferFormModel? date,
    EnumFormState? formState
  }) {
    return CreateOfferFormState(
        status: status ?? this.status,
        description: description ?? this.description,
        price: price ?? this.price,
        city: city ?? this.city,
        countTry: countTry ?? this.countTry,
        expiredAt: expiredAt ?? this.expiredAt,
        date: date ?? this.date,
        formState: formState ?? this.formState
    );
  }
}

