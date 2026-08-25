import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/form/date_offer.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/price.dart';
import 'package:megaladon/data/models/request/params/create/offer_create_request_params.dart';
import 'package:megaladon/data/repositories/offer_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'create_offer_form_state.dart';

class CreateOfferFormCubit extends Cubit<CreateOfferFormState> {
  CreateOfferFormCubit(this.authBloc) : super(const CreateOfferFormState());
  final OfferRepository _repository = OfferRepository();
  final AuthBloc authBloc;

  bool checkCreate({
    required String description,
    required int? price,
    required CityModel? city,
    required String date,
  }) {
    // Описание в отклике необязательно — проверяем только лимит длины.
    var descriptionForm = DescriptionFormModel.dirtyOptional(description);
    var priceFormModel = PriceFormModel.dirty(price);
    var cityForm = CityFormModel.dirty(city?.id);
    var dateForm = DateOfferFormModel.dirty(date);

    var status =
        Formz.validate([descriptionForm, cityForm, priceFormModel, dateForm]);

    var stateNew = state.copyWith(
        description: descriptionForm,
        status: status,
        price: priceFormModel,
        countTry: state.countTry + 1,
        city: cityForm,
        date: dateForm);
    emit(stateNew);
    return stateNew.status;
  }

  Future createFetch(int orderId) async {
    if (state.formState != EnumFormState.fetch) {
      emit(state.copyWith(formState: EnumFormState.fetch));
      return _repository
          .create(
              orderId,
              OfferCreateRequestParams(
                comment: state.description.value,
                price: state.price.value!,
                cityId: state.city.value!,
                date: state.date.value,
              ))
          .then((value) {
        print(value);
        emit(state.copyWith(
          formState: EnumFormState.success,
        ));
      }).catchError((error) {
        print(error);
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
