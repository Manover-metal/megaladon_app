import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum PasswordValidationError implements LocalizableError {
  empty,
  min;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case PasswordValidationError.empty:
        return l10n.form_error_password_empty;
      case PasswordValidationError.min:
        return l10n.form_error_password_min;
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
    } else if (value.length <= 7) {
      return PasswordValidationError.min;
    }
    return null;
  }
}
