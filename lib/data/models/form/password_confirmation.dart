import 'package:formz/formz.dart';

enum PasswordConfirmationValidationError {
  notMatch;

  @override
  String toString() {
    switch (this) {
      case PasswordConfirmationValidationError.notMatch:
        return 'Passwords do not match';
    }
  }
}

class PasswordConfirmationFormModel
    extends FormzInput<String, PasswordConfirmationValidationError> {
  const PasswordConfirmationFormModel.pure(this.password) : super.pure('');
  const PasswordConfirmationFormModel.dirty(this.password, [super.value = ''])
      : super.dirty();
  final String password;

  @override
  PasswordConfirmationValidationError? validator(String value) {
    if (password != value) {
      return PasswordConfirmationValidationError.notMatch;
    }
    return null;
  }
}
