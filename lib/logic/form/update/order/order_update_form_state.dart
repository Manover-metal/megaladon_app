part of 'order_update_form_cubit.dart';

class OrderUpdateFormState extends Equatable {
  const OrderUpdateFormState(
      {this.status = false,
      this.description = const DescriptionFormModel.pure(),
      this.title = const TitleFormModel.pure(),
      this.category = const OrderCategoryFormModel.pure(),
      this.city = const CityFormModel.pure(),
      this.priceMax = const PriceFormModel.pure(),
      this.priceRecommended = const PriceFormModel.pure(),
      this.countTry = 0,
      this.formState = EnumFormState.filled,
      this.files = const [],
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

  OrderUpdateFormState copyWith(
          {bool? status,
          DescriptionFormModel? description,
          TitleFormModel? title,
          PriceFormModel? priceMax,
          PriceFormModel? priceRecommended,
          OrderCategoryFormModel? category,
          CityFormModel? city,
          int? countTry,
          List<PlatformFile>? files,
          EnumFormState? formState,
          ErrorModel? error}) =>
      OrderUpdateFormState(
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
