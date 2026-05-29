import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/form/bin.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/dictionary/multy_service_type.dart';
import 'package:megaladon/data/models/form/lat.dart';
import 'package:megaladon/data/models/form/lon.dart';
import 'package:megaladon/data/models/form/name.dart';

part 'change_executor_form_state.dart';

class ChangeExecutorFormCubit extends Cubit<ChangeExecutorFormState> {
  ChangeExecutorFormCubit() : super(const ChangeExecutorFormState());

  bool checkChangeForm(
      {required String name,
      required String fullAddress,
      required String bin,
      required String lat,
      required String lon,
      required List<ServiceTypeModel> services,
      required CityModel city,
      required String description}) {
    var nameForm = NameFormModel.dirty(name);
    var binForm = BinFormModel.dirty(bin);
    var latForm = LatFormModel.dirty(lat);
    var lonForm = LonFormModel.dirty(lon);
    var servicesForm = MultiServiceTypeFormModel.dirty(services);
    var cityForm = CityFormModel.dirty(city.id);
    var descriptionForm = DescriptionFormModel.dirty(description);

    var status = Formz.validate([
      nameForm,
      binForm,
      latForm,
      lonForm,
      servicesForm,
      cityForm,
      descriptionForm
    ]);

    var stateNew = state.copyWith(
        city: cityForm,
        description: descriptionForm,
        name: nameForm,
        bin: binForm,
        lat: latForm,
        lon: lonForm,
        services: servicesForm,
        status: status,
        countTry: state.countTry + 1);

    emit(stateNew);

    return stateNew.status;
  }
}
