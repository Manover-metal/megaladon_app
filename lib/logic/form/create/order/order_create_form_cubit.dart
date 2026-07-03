import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/dictionary/order_category.dart';
import 'package:megaladon/data/models/form/execution_days.dart';
import 'package:megaladon/data/models/form/price.dart';
import 'package:megaladon/data/models/form/title.dart';
import 'package:megaladon/data/models/request/params/create/order_create_request_params.dart';
import 'package:megaladon/data/repositories/order_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'order_create_form_state.dart';

class OrderCreateFormCubit extends Cubit<OrderCreateFormState> {
  OrderCreateFormCubit(this.authBloc) : super(const OrderCreateFormState());
  final OrderRepository _repository = OrderRepository();
  final AuthBloc authBloc;

  bool checkCreate(
      {required String title,
      required String description,
      required int? priceMax,
      required String executionDays,
      required CityModel? city,
      required OrderCategoryModel category,
      required List<PlatformFile> files}) {
    var titleForm = TitleFormModel.dirty(title);
    var descriptionForm = DescriptionFormModel.dirty(description);
    var priceMaxFormModel = PriceFormModel.dirty(priceMax, false);
    var executionDaysForm = ExecutionDaysFormModel.dirty(executionDays);
    var cityForm = CityFormModel.dirty(city?.id);
    var categoryForm = OrderCategoryFormModel.dirty(category.id);

    var status = Formz.validate([
      titleForm,
      descriptionForm,
      cityForm,
      categoryForm,
      priceMaxFormModel,
      executionDaysForm,
    ]);

    var stateNew = state.copyWith(
        title: titleForm,
        description: descriptionForm,
        status: status,
        countTry: state.countTry + 1,
        city: cityForm,
        category: categoryForm,
        priceMax: priceMaxFormModel,
        executionDays: executionDaysForm,
        files: files);
    emit(stateNew);
    return stateNew.status;
  }

  Future createFetch() async {
    print('a');
    if (state.formState != EnumFormState.fetch) {
      print('b');
      emit(state.copyWith(formState: EnumFormState.fetch));

      var files = <MultipartFile>[];
      for (final file in state.files) {
        if (file.path != null) {
          files.add(
              await MultipartFile.fromFile(file.path!, filename: file.name));
        }
      }

      return await _repository
          .create(OrderCreateRequestParams(
              title: state.title.value,
              description: state.description.value,
              priceMax: state.priceMax.value,
              executionDays: int.tryParse(state.executionDays.value),
              categoryId: state.category.value,
              cityId: state.city.value!,
              files: files))
          .then((value) async {
        print('s');
        emit(state.copyWith(formState: EnumFormState.success));
      }).catchError((error) async {
        print('e');
        if (error is DioException) {
          if (error.response?.statusCode == 403) {
            authBloc.add(AuthLogoutEvent());
          }
          emit(state.copyWith(
              formState: EnumFormState.error,
              error: ErrorModel.parseDio(error)));
        } else {
          emit(state.copyWith(
              formState: EnumFormState.error, error: ErrorModel.nothing));
        }
      });
    }
  }
}
