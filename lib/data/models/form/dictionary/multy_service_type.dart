
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';

enum MultiServiceTypeValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case MultiServiceTypeValidationError.empty:
        return 'Add_at_least_one_service'.tr();
    }
  }
}

class MultiServiceTypeFormModel extends FormzInput<List<ServiceTypeModel>, MultiServiceTypeValidationError> {
  const MultiServiceTypeFormModel.pure() : super.pure(const []);
  const MultiServiceTypeFormModel.dirty([super.value = const []]) : super.dirty();

  @override
  MultiServiceTypeValidationError? validator(List<ServiceTypeModel> value) {
    if (value.isEmpty) {
      return MultiServiceTypeValidationError.empty;
    }

    return null;
  }
}
