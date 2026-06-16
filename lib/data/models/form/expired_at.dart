import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum ExpiredAtValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case ExpiredAtValidationError.empty:
        return l10n.form_error_expired_at_empty;
    }
  }
}

class ExpiredAtFormModel extends FormzInput<String, ExpiredAtValidationError> {
  const ExpiredAtFormModel.pure() : super.pure('');
  const ExpiredAtFormModel.dirty([super.value = '']) : super.dirty();

  @override
  ExpiredAtValidationError? validator(String value) {
    if (value.isEmpty) {
      return ExpiredAtValidationError.empty;
    }
    return null;
  }
}
