part of 'order_update_form_cubit.dart';

class OrderUpdateFormState extends Equatable {
  final FormzStatus status;
  final DescriptionFormModel description;
  final TitleFormModel title;
  final PriceFormModel priceMax;
  final PriceFormModel priceRecommended;
  final OrderCategoryFormModel category ;
  final CityFormModel city;
  final int countTry;
  final EnumFormState formState;


  const OrderUpdateFormState({
    this.status = FormzStatus.pure,
    this.description = const DescriptionFormModel.pure(),
    this.title = const TitleFormModel.pure(),
    this.category = const OrderCategoryFormModel.pure(),
    this.city = const CityFormModel.pure(),
    this.priceMax = const PriceFormModel.pure(),
    this.priceRecommended = const PriceFormModel.pure(),
    this.countTry = 0,
    this.formState = EnumFormState.filled
  });


  @override
  List<Object?> get props => [status, description, title, category, priceMax, priceRecommended, city, countTry];

  OrderUpdateFormState copyWith({
    FormzStatus? status,
    DescriptionFormModel? description,
    TitleFormModel? title,
    PriceFormModel? priceMax,
    PriceFormModel? priceRecommended,
    OrderCategoryFormModel? category,
    CityFormModel? city,
    int? countTry,
    EnumFormState? formState
  }) {
    return OrderUpdateFormState(
      status: status ?? this.status,
      description: description ?? this.description,
      title: title ?? this.title,
      priceMax: priceMax ?? this.priceMax,
      priceRecommended: priceRecommended ?? this.priceRecommended,
      category: category ?? this.category,
      city: city ?? this.city,
      countTry: countTry ?? this.countTry,
      formState: formState ?? this.formState
    );
  }
}

