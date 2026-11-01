import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/category_model.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/dictionary/multy_service_type.dart';
import 'package:megaladon/data/models/form/name.dart';

part 'change_executor_form_state.dart';

/// Проверка формы изменения исполнителя. БИН не проверяем: на экране
/// изменения его нет, он задаётся один раз при регистрации.
class ChangeExecutorFormCubit extends Cubit<ChangeExecutorFormState> {
  ChangeExecutorFormCubit() : super(const ChangeExecutorFormState());

  bool checkChangeForm(
      {required String name,
      required String fullAddress,
      required List<CategoryModel> services}) {
    var nameForm = NameFormModel.dirty(name);
    var servicesForm = MultiServiceTypeFormModel.dirty(services);

    var status = Formz.validate([nameForm, servicesForm]);

    var stateNew = state.copyWith(
        name: nameForm,
        services: servicesForm,
        status: status,
        countTry: state.countTry + 1);

    emit(stateNew);

    return stateNew.status;
  }
}
