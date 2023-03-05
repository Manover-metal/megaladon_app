import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/form/date_offer.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/expired_at.dart';
import 'package:megaladon/data/models/form/price.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/data/models/request/params/offer_create_request_params.dart';
import 'package:megaladon/data/repositories/offer_repository.dart';

part 'create_offer_form_state.dart';

class CreateOfferFormCubit extends Cubit<CreateOfferFormState> {
  final OfferRepository _repository = OfferRepository();
  CreateOfferFormCubit() : super(CreateOfferFormState());

  checkCreate({
    required String description,
    required String price,
    required CityModel city,
    required String expiredAt,
    required String date,
  }) {
    DescriptionFormModel descriptionForm = DescriptionFormModel.dirty(description);
    PriceFormModel priceFormModel = PriceFormModel.dirty(price);
    CityFormModel cityForm = CityFormModel.dirty(city.id);
    ExpiredAtFormModel expiredAtForm = ExpiredAtFormModel.dirty(expiredAt);
    DateOfferFormModel dateForm = DateOfferFormModel.dirty(date);

    FormzStatus status = Formz.validate([
      descriptionForm,
      cityForm,
      priceFormModel,
      expiredAtForm,
      dateForm
    ]);

    CreateOfferFormState stateNew = state.copyWith(
        description: descriptionForm,
        status: status,
        price: priceFormModel,
        countTry: state.countTry + 1,
        city: cityForm,
        expiredAt: expiredAtForm,
        date: dateForm
    );
    emit(stateNew);
    return stateNew.status.isValid;
  }

  Future createFetch(int orderId) async {
    emit(state.copyWith(formState: EnumFormState.fetch));
    return _repository.create(orderId, OfferCreateRequestParams(
      comment: state.description.value,
      price: state.price.value,
      cityId: state.city.value,
      date: state.date.value,
      expiredAt: state.expiredAt.value,
    )).then((value) {
      emit(state.copyWith(formState: EnumFormState.success));
    }).catchError((error) {
      emit(state.copyWith(formState: EnumFormState.error));
    });
  }
}
