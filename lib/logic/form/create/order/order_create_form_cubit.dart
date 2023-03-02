import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/category_model.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/advert_category.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/dictionary/order_category.dart';
import 'package:megaladon/data/models/form/title.dart';
import 'package:megaladon/data/models/form/title.dart';

part 'order_create_form_state.dart';

class OrderCreateFormCubit extends Cubit<OrderCreateFormState> {
  OrderCreateFormCubit() : super(OrderCreateFormState());

  checkCreate({
    required String title,
    required String description,
    required CityModel city,
    required OrderCategoryModel category,
    
  }) {
    TitleFormModel titleForm = TitleFormModel.dirty(title);
    DescriptionFormModel descriptionForm = DescriptionFormModel.dirty(description);
    CityFormModel cityForm = CityFormModel.dirty(city.id);
    OrderCategoryFormModel categoryForm = OrderCategoryFormModel.dirty(category.id);

    FormzStatus status = Formz.validate([
      titleForm,
      descriptionForm,
      cityForm,
      categoryForm
    ]);

    OrderCreateFormState stateNew = state.copyWith(
        title: titleForm,
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
