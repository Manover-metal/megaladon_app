import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum DateOfferValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case DateOfferValidationError.empty:
        return l10n.form_error_date_offer_empty;
    }
  }
}

class DateOfferFormModel extends FormzInput<String, DateOfferValidationError> {
  const DateOfferFormModel.pure() : super.pure('');
  const DateOfferFormModel.dirty([super.value = '']) : super.dirty();

  @override
  DateOfferValidationError? validator(String value) {
    if (value.isEmpty) {
      return DateOfferValidationError.empty;
    }
    return null;
  }
}
