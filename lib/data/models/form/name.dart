import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum NameValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case NameValidationError.empty:
        return l10n.form_error_name_empty;
    }
  }
}

class NameFormModel extends FormzInput<String, NameValidationError> {
  const NameFormModel.pure() : super.pure('');
  const NameFormModel.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) return NameValidationError.empty;
    return null;
  }
}
