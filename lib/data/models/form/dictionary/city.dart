import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum CityValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case CityValidationError.empty:
        return l10n.form_error_city_empty;
    }
  }
}

class CityFormModel extends FormzInput<int?, CityValidationError> {
  const CityFormModel.pure() : super.pure(null);
  const CityFormModel.dirty([super.value]) : super.dirty();

  @override
  CityValidationError? validator(int? value) {
    if (value == null) return CityValidationError.empty;
    return null;
  }
}
