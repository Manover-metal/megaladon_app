
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty, min;

  @override
  String toString() {
    switch(this) {
      case PasswordValidationError.min:
        return 'Password_must_be_at_least_8_characters'.tr();
      case PasswordValidationError.empty:
        return 'Password_is_empty'.tr();
    }
  }
}

class PasswordFormModel extends FormzInput<String, PasswordValidationError> {
  const PasswordFormModel.pure() : super.pure('');
  const PasswordFormModel.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if(value.length <=  7) {
      return PasswordValidationError.min;
    }
    return null;
  }
}
