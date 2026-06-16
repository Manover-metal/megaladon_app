import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum LonValidationError implements LocalizableError {
  empty,
  min,
  max;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case LonValidationError.empty:
        return l10n.form_error_lon_empty;
      case LonValidationError.min:
        return l10n.form_error_lon_min;
      case LonValidationError.max:
        return l10n.form_error_lon_max;
    }
  }
}

class LonFormModel extends FormzInput<String, LonValidationError> {
  const LonFormModel.pure() : super.pure('');
  const LonFormModel.dirty([super.value = '']) : super.dirty();

  @override
  LonValidationError? validator(String value) {
    if (value.isEmpty) {
      return LonValidationError.empty;
    } else if (double.parse(value) < -180) {
      return LonValidationError.min;
    } else if (double.parse(value) > 180) {
      return LonValidationError.max;
    }
    return null;
  }
}
