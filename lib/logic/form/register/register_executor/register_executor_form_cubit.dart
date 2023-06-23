import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/form/bin.dart';
import 'package:megaladon/data/models/form/description.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/lat.dart';
import 'package:megaladon/data/models/form/lon.dart';
import 'package:megaladon/data/models/form/dictionary/multy_service_type.dart';
import 'package:megaladon/data/models/form/name.dart';

part 'register_executor_form_state.dart';

class RegisterExecutorFormCubit extends Cubit<RegisterExecutorFormState> {
  RegisterExecutorFormCubit() : super(const RegisterExecutorFormState());

  bool checkRegisterForm({
    required String name,
    required String fullAddress,
    required String bin,
    required String lat,
    required String lon,
    required CityModel city,
    required String description,
    required List<ServiceTypeModel> services
  }) {
    NameFormModel nameForm = NameFormModel.dirty(name);
    BinFormModel binForm = BinFormModel.dirty(bin);
    LatFormModel latForm = LatFormModel.dirty(lat);
    LonFormModel lonForm = LonFormModel.dirty(lon);
    MultiServiceTypeFormModel servicesForm = MultiServiceTypeFormModel.dirty(services);
    CityFormModel cityForm = CityFormModel.dirty(city.id);
    DescriptionFormModel descriptionForm = DescriptionFormModel.dirty(description);


    FormzStatus status = Formz.validate([
      nameForm,
      binForm,
      latForm,
      lonForm,
      servicesForm,
      cityForm,
      descriptionForm
    ]);

    RegisterExecutorFormState stateNew = state.copyWith(
        city: cityForm,

        name: nameForm,
        bin: binForm,
        lat: latForm,
        lon: lonForm,
        services: servicesForm,
        status: status,
        countTry: state.countTry + 1
    );

    emit(stateNew);

    return stateNew.status.isValid;
  }
}
