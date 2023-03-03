part of 'ad_create_form_cubit.dart';

enum AdCreateForm {
  filled,
  loaded,
  error,
  success
}

class AdCreateFormState extends Equatable {
  final FormzStatus status;
  final DescriptionFormModel description;
  final TitleFormModel title;
  final PriceFormModel price;
  final AdvertCategoryFormModel category ;
  final CityFormModel city;
  final int countTry;


  const AdCreateFormState({
    this.status = FormzStatus.pure,
    this.description = const DescriptionFormModel.pure(),
    this.title = const TitleFormModel.pure(),
    this.category = const AdvertCategoryFormModel.pure(),
    this.city = const CityFormModel.pure(),
    this.countTry = 0,
    this.price = const PriceFormModel.pure(),
  });


  @override
  List<Object?> get props => [status, description, price, title, category, city, countTry];

  AdCreateFormState copyWith({
    FormzStatus? status,
    DescriptionFormModel? description,
    TitleFormModel? title,
    AdvertCategoryFormModel? category,
    CityFormModel? city,
    int? countTry,
    AdCreateForm? state,
    PriceFormModel? price
  }) {
    return AdCreateFormState(
      status: status ?? this.status,
      description: description ?? this.description,
      title: title ?? this.title,
      category: category ?? this.category,
      city: city ?? this.city,
      price: price ?? this.price,
      countTry: countTry ?? this.countTry,
    );
  }
}

