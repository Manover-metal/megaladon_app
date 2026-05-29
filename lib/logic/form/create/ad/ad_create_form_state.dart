part of 'ad_create_form_cubit.dart';

enum AdCreateForm { filled, loaded, error, success }

class AdCreateFormState extends Equatable {
  const AdCreateFormState(
      {this.status = false,
      this.description = const DescriptionFormModel.pure(),
      this.title = const TitleFormModel.pure(),
      this.category = const AdvertCategoryFormModel.pure(),
      this.city = const CityFormModel.pure(),
      this.countTry = 0,
      this.price = const PriceFormModel.pure(),
      this.phone = const PhoneFormModel.pure(),
      this.media = const [],
      this.formState = EnumFormState.filled,
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
  final List<PlatformFile> media;
  final AdvertType type;
  final ErrorModel? error;

  @override
  List<Object?> get props => [
        status,
        description,
        price,
        title,
        category,
        city,
        countTry,
        formState,
        phone,
        media,
        type,
        error
      ];

  AdCreateFormState copyWith(
          {bool? status,
          DescriptionFormModel? description,
          TitleFormModel? title,
          AdvertCategoryFormModel? category,
          CityFormModel? city,
          int? countTry,
          AdCreateForm? state,
          PriceFormModel? price,
          PhoneFormModel? phone,
          List<PlatformFile>? media,
          EnumFormState? formState,
          AdvertType? type,
          ErrorModel? error}) =>
      AdCreateFormState(
          status: status ?? this.status,
          description: description ?? this.description,
          title: title ?? this.title,
          category: category ?? this.category,
          city: city ?? this.city,
          price: price ?? this.price,
          countTry: countTry ?? this.countTry,
          formState: formState ?? this.formState,
          phone: phone ?? this.phone,
          media: media ?? this.media,
          type: type ?? this.type,
          error: error ?? this.error);
}
