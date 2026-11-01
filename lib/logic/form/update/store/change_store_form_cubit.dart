import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/dictionary/multy_contact_model.dart';
import 'package:megaladon/data/models/form/name.dart';

part 'change_store_form_state.dart';

/// Проверка формы изменения магазина. БИН не проверяем: на экране изменения
/// его нет, он задаётся один раз при регистрации.
class ChangeStoreFormCubit extends Cubit<ChangeStoreFormState> {
  ChangeStoreFormCubit() : super(const ChangeStoreFormState());

  bool checkChangeForm({
    required String name,
    required String fullAddress,
    required CityModel? city,
    required List<ContactModel> contacts,
  }) {
    var nameForm = NameFormModel.dirty(name);
    var cityForm = CityFormModel.dirty(city?.id);
    var contactsForm = MultiContactFormModel.dirty(contacts);

    final status = Formz.validate([nameForm, cityForm, contactsForm]);

    var stateNew = state.copyWith(
        name: nameForm,
        city: cityForm,
        contacts: contactsForm,
        status: status,
        countTry: state.countTry + 1);

    emit(stateNew);

    return stateNew.status;
  }
}
