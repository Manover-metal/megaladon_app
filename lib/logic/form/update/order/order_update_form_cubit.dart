import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/dictionary/order_category.dart';
import 'package:megaladon/data/models/form/price.dart';
import 'package:megaladon/data/models/form/title.dart';
import 'package:megaladon/data/models/request/params/update/order_update_request_params.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_update_form_state.dart';

class OrderUpdateFormCubit extends Cubit<OrderUpdateFormState> {
  final OrderRepository _repository = OrderRepository();
  OrderUpdateFormCubit() : super(const OrderUpdateFormState());

  checkUpdate({
    required String title,
    required String description,
    required String priceMax,
    required String priceRecommended,
    required CityModel city,
    required OrderCategoryModel category,
    
  }) {
    TitleFormModel titleForm = TitleFormModel.dirty(title);
    DescriptionFormModel descriptionForm = DescriptionFormModel.dirty(description);
    PriceFormModel priceMaxFormModel = PriceFormModel.dirty(priceMax);
    PriceFormModel priceRecommendedFormModel = PriceFormModel.dirty(priceRecommended);

    CityFormModel cityForm = CityFormModel.dirty(city.id);
    OrderCategoryFormModel categoryForm = OrderCategoryFormModel.dirty(category.id);

    bool status = Formz.validate([
      titleForm,
      descriptionForm,
      cityForm,
      categoryForm,
      priceMaxFormModel,
      priceRecommendedFormModel
    ]);

    OrderUpdateFormState stateNew = state.copyWith(
        title: titleForm,
        description: descriptionForm,
        status: status,
        countTry: state.countTry + 1,
        city: cityForm,
        category: categoryForm,
        priceMax: priceMaxFormModel,
        priceRecommended: priceRecommendedFormModel
    );
    emit(stateNew);
    return stateNew.status;
  }

  Future updateFetch(int id) async {
    emit(state.copyWith(formState: EnumFormState.fetch));
    return _repository.update(id, OrderUpdateRequestParams(
        title: state.title.value,
        description: state.title.value,
        priceMax: int.parse(state.priceMax.value),
        priceRecommended: int.parse(state.priceRecommended.value),
        categoryId: state.category.value,
        cityId: state.city.value,
    )).then((value) {
      emit(state.copyWith(formState: EnumFormState.success));
    }).catchError((error) {
      emit(state.copyWith(formState: EnumFormState.error));
    });
  }
}
