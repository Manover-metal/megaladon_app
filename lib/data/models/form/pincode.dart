
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum PincodeValidationError {
  empty,
  min;
  @override
  String toString() {
    switch(this) {
      case PincodeValidationError.empty:
        return 'Code_is_empty'.tr();
      case PincodeValidationError.min:
        return 'Code_is_6_characters'.tr();
    }
  }
}

class PincodeFormModel extends FormzInput<String, PincodeValidationError> {
  const PincodeFormModel.pure() : super.pure('');
  const PincodeFormModel.dirty([super.value = '']) : super.dirty();

  @override
  PincodeValidationError? validator(String value) {
    if (value.isEmpty) {
      return PincodeValidationError.empty;
    }
    else if (value.length < 6) {
      return PincodeValidationError.min;
    }
    return null;
  }
}
