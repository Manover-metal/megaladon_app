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
import 'package:megaladon/data/models/form/price.dart';
import 'package:megaladon/data/models/form/title.dart';
import 'package:megaladon/data/models/form/title.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/params/order_create_request_params.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_create_form_state.dart';

class OrderCreateFormCubit extends Cubit<OrderCreateFormState> {
  final OrderRepository _repository = OrderRepository();
  OrderCreateFormCubit() : super(OrderCreateFormState());

  checkCreate({
    required String title,
    required String description,
    required int? priceMax,
    required int? priceRecommended,
    required CityModel city,
    required OrderCategoryModel category,
    
  }) {
    TitleFormModel titleForm = TitleFormModel.dirty(title);
    DescriptionFormModel descriptionForm = DescriptionFormModel.dirty(description);
    PriceFormModel priceMaxFormModel = PriceFormModel.dirty(priceMax);
    PriceFormModel priceRecommendedFormModel = PriceFormModel.dirty(priceRecommended);

    CityFormModel cityForm = CityFormModel.dirty(city.id);
    OrderCategoryFormModel categoryForm = OrderCategoryFormModel.dirty(category.id);

    FormzStatus status = Formz.validate([
      titleForm,
      descriptionForm,
      cityForm,
      categoryForm,
      priceMaxFormModel,
      priceRecommendedFormModel
    ]);

    OrderCreateFormState stateNew = state.copyWith(
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
    return stateNew.status.isValid;
  }

  Future<OrderModel> createFetch() async {
    return _repository.create(OrderCreateRequestParams(
        title: state.title.value,
        description: state.title.value,
        priceMax: state.priceMax.value!,
        priceRecommended: state.priceRecommended.value!,
        categoryId: state.category.value,
        cityId: state.city.value,
        additionalPhone: '+77074054407',
    ));
  }
}
