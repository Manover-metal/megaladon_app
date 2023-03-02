import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/category_model.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/advert_category.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/name.dart';

part 'ad_create_form_state.dart';

class AdCreateFormCubit extends Cubit<AdCreateFormState> {
  AdCreateFormCubit() : super(AdCreateFormState());

  checkCreate({
    required String name,
    required String description,
    required CityModel city,
    required AdvertCategoryModel category,
    
  }) {
    NameFormModel nameForm = NameFormModel.dirty(name);
    DescriptionFormModel descriptionForm = DescriptionFormModel.dirty(description);
    CityFormModel cityForm = CityFormModel.dirty(city.id);
    AdvertCategoryFormModel categoryForm = AdvertCategoryFormModel.dirty(category.id);

    FormzStatus status = Formz.validate([
      nameForm,
      descriptionForm,
      cityForm,
      categoryForm
    ]);

    AdCreateFormState stateNew = state.copyWith(
        name: nameForm,
        description: descriptionForm,
        status: status,
        countTry: state.countTry + 1,
        city: cityForm,
        category: categoryForm
    );
    emit(stateNew);
    return stateNew.status.isValid;
  }
}
