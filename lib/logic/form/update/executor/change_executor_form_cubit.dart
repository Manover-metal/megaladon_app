import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/dictionary/multy_service_type.dart';
import 'package:megaladon/data/models/form/lat.dart';
import 'package:megaladon/data/models/form/lon.dart';
import 'package:megaladon/data/models/form/name.dart';

part 'change_executor_form_state.dart';

/// Проверка формы изменения исполнителя. БИН не проверяем: на экране
/// изменения его нет, он задаётся один раз при регистрации.
class ChangeExecutorFormCubit extends Cubit<ChangeExecutorFormState> {
  ChangeExecutorFormCubit() : super(const ChangeExecutorFormState());

  bool checkChangeForm(
      {required String name,
      required String fullAddress,
      required String lat,
      required String lon,
      required List<ServiceTypeModel> services}) {
    var nameForm = NameFormModel.dirty(name);
    var latForm = LatFormModel.dirty(lat);
    var lonForm = LonFormModel.dirty(lon);
    var servicesForm = MultiServiceTypeFormModel.dirty(services);

    var status = Formz.validate([nameForm, latForm, lonForm, servicesForm]);

    var stateNew = state.copyWith(
        name: nameForm,
        lat: latForm,
        lon: lonForm,
        services: servicesForm,
        status: status,
        countTry: state.countTry + 1);

    emit(stateNew);

    return stateNew.status;
  }
}
