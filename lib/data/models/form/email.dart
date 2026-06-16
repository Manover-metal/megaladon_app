import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum EmailValidationError implements LocalizableError {
  empty,
  notEmail;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case EmailValidationError.empty:
        return l10n.form_error_email_empty;
      case EmailValidationError.notEmail:
        return l10n.form_error_email_invalid;
    }
  }
}

class EmailFormModel extends FormzInput<String, EmailValidationError> {
  const EmailFormModel.pure() : super.pure('');
  const EmailFormModel.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    } else if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value) ==
        false) {
      return EmailValidationError.notEmail;
    }
    return null;
  }
}
