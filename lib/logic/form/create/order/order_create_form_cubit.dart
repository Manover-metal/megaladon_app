import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/dictionary/order_category.dart';
import 'package:megaladon/data/models/form/price.dart';
import 'package:megaladon/data/models/form/title.dart';
import 'package:megaladon/data/models/request/params/create/order_create_request_params.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_create_form_state.dart';

class OrderCreateFormCubit extends Cubit<OrderCreateFormState> {
  final OrderRepository _repository = OrderRepository();
  OrderCreateFormCubit() : super(const OrderCreateFormState());

  checkCreate({
    required String title,
    required String description,
    required String priceMax,
    required String priceRecommended,
    required CityModel city,
    required OrderCategoryModel category,
    required List<PlatformFile> files
  }) {
    TitleFormModel titleForm = TitleFormModel.dirty(title);
    DescriptionFormModel descriptionForm = DescriptionFormModel.dirty(description);
    PriceFormModel priceMaxFormModel = PriceFormModel.dirty(priceMax, false);
    PriceFormModel priceRecommendedFormModel = PriceFormModel.dirty(priceRecommended, false);
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

    OrderCreateFormState stateNew = state.copyWith(
        title: titleForm,
        description: descriptionForm,
        status: status,
        countTry: state.countTry + 1,
        city: cityForm,
        category: categoryForm,
        priceMax: priceMaxFormModel,
        priceRecommended: priceRecommendedFormModel,
        files: files
    );
    emit(stateNew);
    return stateNew.status;
  }

  Future createFetch() async {
    if (state.formState != EnumFormState.fetch) {
      emit(state.copyWith(formState: EnumFormState.fetch));

      List<MultipartFile> files = [];
      for (var file in state.files) {
        if (file.path != null) {
          files.add(
              await MultipartFile.fromFile(file.path!, filename: file.name));
        }
      }

      return _repository.create(OrderCreateRequestParams(
          title: state.title.value,
          description: state.description.value,
          priceMax: int.tryParse(state.priceMax.value),
          priceRecommended: int.tryParse(state.priceRecommended.value),
          categoryId: state.category.value,
          cityId: state.city.value,
          files: files
      )).then((value) {
        emit(state.copyWith(formState: EnumFormState.success));
      }).catchError((error) {
        print(error);
        emit(state.copyWith(formState: EnumFormState.error));
      });
    }
  }
}
