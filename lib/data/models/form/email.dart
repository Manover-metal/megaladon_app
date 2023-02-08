
import 'package:formz/formz.dart';

enum EmailValidationError { empty, notEmail }

class EmailFormModel extends FormzInput<String, EmailValidationError> {
  const EmailFormModel.pure() : super.pure('');
  const EmailFormModel.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    } else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) == false) {
      return EmailValidationError.notEmail;
    }
    return null;
  }
}
