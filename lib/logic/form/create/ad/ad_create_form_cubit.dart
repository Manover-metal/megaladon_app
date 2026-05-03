import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/advert_category.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/phone.dart';
import 'package:megaladon/data/models/form/price.dart';
import 'package:megaladon/data/models/form/title.dart';
import 'package:megaladon/data/models/request/params/create/advert_create_request_params.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';

part 'ad_create_form_state.dart';

class AdCreateFormCubit extends Cubit<AdCreateFormState> {
  final AdvertRepository _repository = AdvertRepository();
  AdCreateFormCubit() : super(const AdCreateFormState());

  checkCreate({
    required String title,
    required String description,
    required String price,
    required CityModel city,
    required AdvertCategoryModel category,
    required String phone,
    required List<PlatformFile> media,
    required AdvertType type,
  }) {
    TitleFormModel titleForm = TitleFormModel.dirty(title);
    PriceFormModel priceForm = PriceFormModel.dirty(price, false);
    DescriptionFormModel descriptionForm = DescriptionFormModel.dirty(description);
    CityFormModel cityForm = CityFormModel.dirty(city.id);
    AdvertCategoryFormModel categoryForm = AdvertCategoryFormModel.dirty(category.id);
    PhoneFormModel phoneForm = PhoneFormModel.dirty(phone, false);

    final status = Formz.validate([
      titleForm,
      descriptionForm,
      cityForm,
      categoryForm,
      priceForm,
      phoneForm
    ]);

    AdCreateFormState stateNew = state.copyWith(
        title: titleForm,
        description: descriptionForm,
        status: status,
        countTry: state.countTry + 1,
        city: cityForm,
        category: categoryForm,
        price: priceForm,
        phone: phoneForm,
        media: media,
        type: type
    );
    print(type);
    emit(stateNew);
    return stateNew.status;
  }

  Future createFetch() async {
    if(state.formState != EnumFormState.fetch) {
      emit(state.copyWith(formState: EnumFormState.fetch));

      List<MultipartFile> files = [];

      for (var file in state.media) {
        if(file.path != null) {
          files.add(await MultipartFile.fromFile(file.path!, filename: file.name));
        }
      }

      return _repository.create(AdvertCreateRequestParams(
        title: state.title.value,
        description: state.title.value,
        price: int.parse(state.price.value),
        categoryId: state.category.value,
        cityId: state.city.value,
        additionalPhone: state.phone.value,
        media: files,
        type: state.type
      )).then((value) {
        emit(state.copyWith(formState: EnumFormState.success));
      }).catchError((error) {
        print(error);
        emit(state.copyWith(formState: EnumFormState.error));
      });
    }
  }
}
