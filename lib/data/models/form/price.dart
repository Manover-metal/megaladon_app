import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum PriceValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case PriceValidationError.empty:
        return l10n.form_error_price_empty;
    }
  }
}

class PriceFormModel extends FormzInput<int?, PriceValidationError> {
  const PriceFormModel.pure([this.isRequired = true]) : super.pure(null);
  const PriceFormModel.dirty([int? value, this.isRequired = true])
      : super.dirty(value);
  final bool isRequired;

  @override
  PriceValidationError? validator(int? value) {
    if (value == null && isRequired) return PriceValidationError.empty;
    return null;
  }
}
