import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum PincodeValidationError implements LocalizableError {
  empty,
  min;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case PincodeValidationError.empty:
        return l10n.form_error_pincode_empty;
      case PincodeValidationError.min:
        return l10n.form_error_pincode_min;
    }
  }
}

class PincodeFormModel extends FormzInput<String, PincodeValidationError> {
  const PincodeFormModel.pure() : super.pure('');
  const PincodeFormModel.dirty([super.value = '']) : super.dirty();

  @override
  PincodeValidationError? validator(String value) {
    if (value.isEmpty) {
      return PincodeValidationError.empty;
    } else if (value.length < 6) {
      return PincodeValidationError.min;
    }
    return null;
  }
}
