import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';
import 'package:megaladon/data/models/form/bin.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/dictionary/multy_contact_model.dart';
import 'package:megaladon/data/models/form/dictionary/store_type.dart';
import 'package:megaladon/data/models/form/lat.dart';
import 'package:megaladon/data/models/form/lon.dart';
import 'package:megaladon/data/models/form/name.dart';


part 'change_store_form_state.dart';

class ChangeStoreFormCubit extends Cubit<ChangeStoreFormState> {
  ChangeStoreFormCubit() : super(const ChangeStoreFormState());

  bool checkChangeForm({
    required String name,
    required String fullAddress,
    required String bin,
    required String lat,
    required String lon,
    required StoreTypeModel type,
    required CityModel city,
    required List<ContactModel> contacts,
  }) {
    NameFormModel nameForm = NameFormModel.dirty(name);
    BinFormModel binForm = BinFormModel.dirty(bin);
    LatFormModel latForm = LatFormModel.dirty(lat);
    LonFormModel lonForm = LonFormModel.dirty(lon);
    CityFormModel cityForm = CityFormModel.dirty(city.id);
    StoreTypeFormModel typeForm = StoreTypeFormModel.dirty(type.id);
    MultiContactFormModel contactsForm = MultiContactFormModel.dirty(contacts);


    final status = Formz.validate([
      nameForm,
      binForm,
      latForm,
      lonForm,
      cityForm,
      typeForm,
      contactsForm
    ]);

    ChangeStoreFormState stateNew = state.copyWith(
        name: nameForm,
        bin: binForm,
        city: cityForm,
        type: typeForm,
        lat: latForm,
        lon: lonForm,
        contacts: contactsForm,
        status: status,
        countTry: state.countTry + 1
    );

    emit(stateNew);

    return stateNew.status;
  }
}
