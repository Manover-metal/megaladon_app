import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum LatValidationError implements LocalizableError {
  empty,
  min,
  max;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case LatValidationError.empty:
        return l10n.form_error_lat_empty;
      case LatValidationError.min:
        return l10n.form_error_lat_min;
      case LatValidationError.max:
        return l10n.form_error_lat_max;
    }
  }
}

class LatFormModel extends FormzInput<String, LatValidationError> {
  const LatFormModel.pure() : super.pure('');
  const LatFormModel.dirty([super.value = '']) : super.dirty();

  @override
  LatValidationError? validator(String value) {
    if (value.isEmpty) {
      return LatValidationError.empty;
    } else if (double.parse(value) < -90) {
      return LatValidationError.min;
    } else if (double.parse(value) > 90) {
      return LatValidationError.max;
    }
    return null;
  }
}
