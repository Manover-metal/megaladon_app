part of 'order_create_form_cubit.dart';

class OrderCreateFormState extends Equatable {
  final FormzStatus status;
  final DescriptionFormModel description;
  final TitleFormModel title;
  final OrderCategoryFormModel category ;
  final CityFormModel city;
  final int countTry;


  const OrderCreateFormState({
    this.status = FormzStatus.pure,
    this.description = const DescriptionFormModel.pure(),
    this.title = const TitleFormModel.pure(),
    this.category = const OrderCategoryFormModel.pure(),
    this.city = const CityFormModel.pure(),
    this.countTry = 0
  });


  @override
  List<Object?> get props => [status, description, title, category, city, countTry];

  OrderCreateFormState copyWith({
    FormzStatus? status,
    DescriptionFormModel? description,
    TitleFormModel? title,
    OrderCategoryFormModel? category,
    CityFormModel? city,
    int? countTry
  }) {
    return OrderCreateFormState(
      status: status ?? this.status,
      description: description ?? this.description,
      title: title ?? this.title,
      category: category ?? this.category,
      city: city ?? this.city,
      countTry: countTry ?? this.countTry
    );
  }
}

