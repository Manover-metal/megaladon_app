import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/category_model.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/advert_category.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/price.dart';
import 'package:megaladon/data/models/form/title.dart';
import 'package:megaladon/data/models/form/title.dart';
import 'package:megaladon/data/models/request/params/advert_create_request_params.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';

part 'ad_create_form_state.dart';

class AdCreateFormCubit extends Cubit<AdCreateFormState> {
  final AdvertRepository _repository = AdvertRepository();
  AdCreateFormCubit() : super(AdCreateFormState());

  checkCreate({
    required String title,
    required String description,
    required int? price,
    required CityModel city,
    required AdvertCategoryModel category,
  }) {
    TitleFormModel titleForm = TitleFormModel.dirty(title);
    PriceFormModel priceForm = PriceFormModel.dirty(price);
    DescriptionFormModel descriptionForm = DescriptionFormModel.dirty(description);
    CityFormModel cityForm = CityFormModel.dirty(city.id);
    AdvertCategoryFormModel categoryForm = AdvertCategoryFormModel.dirty(category.id);

    FormzStatus status = Formz.validate([
      titleForm,
      descriptionForm,
      cityForm,
      categoryForm,
      priceForm
    ]);

    AdCreateFormState stateNew = state.copyWith(
        title: titleForm,
        description: descriptionForm,
        status: status,
        countTry: state.countTry + 1,
        city: cityForm,
        category: categoryForm,
        price: priceForm
    );
    emit(stateNew);
    return stateNew.status.isValid;
  }

  Future<AdvertModel> createFetch() async {
    return _repository.create(AdvertCreateRequestParams(
      title: state.title.value,
      description: state.title.value,
      price: state.price.value!,
      categoryId: state.category.value,
      cityId: state.city.value,
      additionalPhone: '+77074054407'
    ));
  }
}
