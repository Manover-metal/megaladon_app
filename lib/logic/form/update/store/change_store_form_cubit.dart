import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/dictionary/multy_contact_model.dart';
import 'package:megaladon/data/models/form/lat.dart';
import 'package:megaladon/data/models/form/lon.dart';
import 'package:megaladon/data/models/form/name.dart';

part 'change_store_form_state.dart';

/// Проверка формы изменения магазина. БИН не проверяем: на экране изменения
/// его нет, он задаётся один раз при регистрации.
class ChangeStoreFormCubit extends Cubit<ChangeStoreFormState> {
  ChangeStoreFormCubit() : super(const ChangeStoreFormState());

  bool checkChangeForm({
    required String name,
    required String fullAddress,
    required String lat,
    required String lon,
    required CityModel? city,
    required List<ContactModel> contacts,
  }) {
    var nameForm = NameFormModel.dirty(name);
    var latForm = LatFormModel.dirty(lat);
    var lonForm = LonFormModel.dirty(lon);
    var cityForm = CityFormModel.dirty(city?.id);
    var contactsForm = MultiContactFormModel.dirty(contacts);

    final status =
        Formz.validate([nameForm, latForm, lonForm, cityForm, contactsForm]);

    var stateNew = state.copyWith(
        name: nameForm,
        city: cityForm,
        lat: latForm,
        lon: lonForm,
        contacts: contactsForm,
        status: status,
        countTry: state.countTry + 1);

    emit(stateNew);

    return stateNew.status;
  }
}
