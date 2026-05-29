part of 'ad_update_form_cubit.dart';

enum AdUpdateForm { filled, loaded, error, success }

class AdUpdateFormState extends Equatable {
  const AdUpdateFormState(
      {this.status = false,
      this.description = const DescriptionFormModel.pure(),
      this.title = const TitleFormModel.pure(),
      this.category = const AdvertCategoryFormModel.pure(),
      this.city = const CityFormModel.pure(),
      this.countTry = 0,
      this.price = const PriceFormModel.pure(),
      this.phone = const PhoneFormModel.pure(),
      this.formState = EnumFormState.filled,
      this.media = const [],
      this.type = AdvertType.advert,
      this.error});
  final bool status;
  final DescriptionFormModel description;
  final TitleFormModel title;
  final PriceFormModel price;
  final AdvertCategoryFormModel category;
  final CityFormModel city;
  final PhoneFormModel phone;
  final int countTry;
  final EnumFormState formState;
  final AdvertType type;
  final List<PlatformFile> media;
  final ErrorModel? error;

  @override
  List<Object?> get props => [
        status,
        description,
        price,
        title,
        category,
        city,
        phone,
        countTry,
        media,
        error,
        formState
      ];

  AdUpdateFormState copyWith({
    bool? status,
    DescriptionFormModel? description,
    TitleFormModel? title,
    AdvertCategoryFormModel? category,
    CityFormModel? city,
    int? countTry,
    AdUpdateForm? state,
    PriceFormModel? price,
    PhoneFormModel? phone,
    EnumFormState? formState,
    List<PlatformFile>? media,
    AdvertType? type,
    ErrorModel? error,
  }) =>
      AdUpdateFormState(
          status: status ?? this.status,
          description: description ?? this.description,
          title: title ?? this.title,
          category: category ?? this.category,
          city: city ?? this.city,
          price: price ?? this.price,
          phone: phone ?? this.phone,
          countTry: countTry ?? this.countTry,
          formState: formState ?? this.formState,
          type: type ?? this.type,
          media: media ?? this.media,
          error: error ?? this.error);
}
