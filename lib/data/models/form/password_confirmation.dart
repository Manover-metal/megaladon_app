import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum PasswordConfirmationValidationError implements LocalizableError {
  notMatch;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case PasswordConfirmationValidationError.notMatch:
        return l10n.form_error_password_confirmation_not_match;
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
