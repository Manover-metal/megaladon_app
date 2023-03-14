import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/form/bin.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/lat.dart';
import 'package:megaladon/data/models/form/lon.dart';
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
    required List<ServiceTypeModel> services
  }) {
    NameFormModel nameForm = NameFormModel.dirty(name);
    BinFormModel binForm = BinFormModel.dirty(bin);
    LatFormModel latForm = LatFormModel.dirty(lat);
    LonFormModel lonForm = LonFormModel.dirty(lon);


    FormzStatus status = Formz.validate([
      nameForm,
      binForm,
      latForm,
      lonForm
    ]);

    RegisterExecutorFormState stateNew = state.copyWith(
        name: nameForm,
        bin: binForm,
        lat: latForm,
        lon: lonForm,
        status: status,
        countTry: state.countTry + 1
    );

    emit(stateNew);

    return stateNew.status.isValid;
  }
}
