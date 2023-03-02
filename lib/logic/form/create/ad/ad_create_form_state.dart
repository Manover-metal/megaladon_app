part of 'ad_create_form_cubit.dart';

class AdCreateFormState extends Equatable {
  final FormzStatus status;
  final DescriptionFormModel description;
  final NameFormModel name;
  final AdvertCategoryFormModel category ;
  final CityFormModel city;
  final int countTry;


  const AdCreateFormState({
    this.status = FormzStatus.pure,
    this.description = const DescriptionFormModel.pure(),
    this.name = const NameFormModel.pure(),
    this.category = const AdvertCategoryFormModel.pure(),
    this.city = const CityFormModel.pure(),
    this.countTry = 0
  });


  @override
  List<Object?> get props => [status, description, name, category, city, countTry];

  AdCreateFormState copyWith({
    FormzStatus? status,
    DescriptionFormModel? description,
    NameFormModel? name,
    AdvertCategoryFormModel? category,
    CityFormModel? city,
    int? countTry
  }) {
    return AdCreateFormState(
      status: status ?? this.status,
      description: description ?? this.description,
      name: name ?? this.name,
      category: category ?? this.category,
      city: city ?? this.city,
      countTry: countTry ?? this.countTry
    );
  }
}

