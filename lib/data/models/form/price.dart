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

class PriceFormModel extends FormzInput<String, PriceValidationError> {
  const PriceFormModel.pure([this.isRequired = true]) : super.pure('');
  const PriceFormModel.dirty([super.value = '', this.isRequired = true])
      : super.dirty();
  final bool isRequired;

  @override
  PriceValidationError? validator(String value) {
    if (value.isEmpty && isRequired) return PriceValidationError.empty;
    return null;
  }
}
