import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum BinValidationError implements LocalizableError {
  empty,
  min,
  max;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case BinValidationError.empty:
        return l10n.form_error_bin_empty;
      case BinValidationError.min:
        return l10n.form_error_bin_min;
      case BinValidationError.max:
        return l10n.form_error_bin_max;
    }
  }
}

class BinFormModel extends FormzInput<String, BinValidationError> {
  const BinFormModel.pure() : super.pure('');
  const BinFormModel.dirty([super.value = '']) : super.dirty();

  @override
  BinValidationError? validator(String value) {
    if (value.isEmpty) {
      return BinValidationError.empty;
    } else if (value.length < 12) {
      return BinValidationError.min;
    } else if (value.length >= 13) {
      return BinValidationError.max;
    }
    return null;
  }
}
