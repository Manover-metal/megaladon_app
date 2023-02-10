
import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty, min;

  @override
  String toString() {
    switch(this) {
      case PasswordValidationError.min:
        return 'Пароль должен состоять минимально из 8 символов';
      case PasswordValidationError.empty:
        return 'Пароль пустой';
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
