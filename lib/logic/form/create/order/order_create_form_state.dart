part of 'order_create_form_cubit.dart';

class OrderCreateFormState extends Equatable {
  const OrderCreateFormState(
      {this.status = false,
      this.description = const DescriptionFormModel.pure(),
      this.title = const TitleFormModel.pure(),
      this.category = const OrderCategoryFormModel.pure(),
      this.city = const CityFormModel.pure(),
      this.priceMax = const PriceFormModel.pure(),
      this.priceRecommended = const PriceFormModel.pure(),
      this.files = const [],
      this.countTry = 0,
      this.formState = EnumFormState.filled,
      this.error});
  final bool status;
  final DescriptionFormModel description;
  final TitleFormModel title;
  final PriceFormModel priceMax;
  final PriceFormModel priceRecommended;
  final OrderCategoryFormModel category;
  final CityFormModel city;
  final int countTry;
  final EnumFormState formState;
  final List<PlatformFile> files;
  final ErrorModel? error;

  @override
  List<Object?> get props => [
        status,
        description,
        title,
        category,
        priceMax,
        priceRecommended,
        city,
        countTry,
        files,
        error,
        formState
      ];

  OrderCreateFormState copyWith(
          {bool? status,
          DescriptionFormModel? description,
          TitleFormModel? title,
          PriceFormModel? priceMax,
          PriceFormModel? priceRecommended,
          OrderCategoryFormModel? category,
          CityFormModel? city,
          List<PlatformFile>? files,
          int? countTry,
          EnumFormState? formState,
          ErrorModel? error}) =>
      OrderCreateFormState(
          status: status ?? this.status,
          description: description ?? this.description,
          title: title ?? this.title,
          priceMax: priceMax ?? this.priceMax,
          priceRecommended: priceRecommended ?? this.priceRecommended,
          category: category ?? this.category,
          city: city ?? this.city,
          countTry: countTry ?? this.countTry,
          formState: formState ?? this.formState,
          files: files ?? this.files,
          error: error ?? this.error);
}
