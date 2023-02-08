
import 'package:formz/formz.dart';

enum PhoneValidationError { empty }

class PhoneFormModel extends FormzInput<String, PhoneValidationError> {
  const PhoneFormModel.pure() : super.pure('');
  const PhoneFormModel.dirty([super.value = '']) : super.dirty();

  @override
  PhoneValidationError? validator(String value) {
    if (value.isEmpty) {
      return PhoneValidationError.empty;
    }
    return null;
  }
}
