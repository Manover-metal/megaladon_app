
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum PasswordConfirmationValidationError {
  notMatch;

  @override
  String toString() {
    switch(this) {
      case PasswordConfirmationValidationError.notMatch:
        return 'Passwords_do_not_match'.tr();
    }
  }
}

class PasswordConfirmationFormModel extends FormzInput<String, PasswordConfirmationValidationError> {
  final String password;

  const PasswordConfirmationFormModel.pure(this.password) : super.pure('');
  const PasswordConfirmationFormModel.dirty(this.password, [super.value = '']) : super.dirty();

  @override
  PasswordConfirmationValidationError? validator(String value) {
    if (password != value) {
      return PasswordConfirmationValidationError.notMatch;
    }
    return null;
  }
}
