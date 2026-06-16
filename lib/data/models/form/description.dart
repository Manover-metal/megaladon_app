import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum DescriptionValidationError implements LocalizableError {
  empty,
  limit;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case DescriptionValidationError.empty:
        return l10n.form_error_description_empty;
      case DescriptionValidationError.limit:
        return l10n.form_error_description_limit;
    }
  }
}

class DescriptionFormModel
    extends FormzInput<String, DescriptionValidationError> {
  const DescriptionFormModel.pure() : super.pure('');
  const DescriptionFormModel.dirty([super.value = '']) : super.dirty();

  @override
  DescriptionValidationError? validator(String value) {
    if (value.isEmpty) return DescriptionValidationError.empty;
    if (value.length > 1000) return DescriptionValidationError.limit;
    return null;
  }
}
