import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum TitleValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case TitleValidationError.empty:
        return l10n.form_error_title_empty;
    }
  }
}

class TitleFormModel extends FormzInput<String, TitleValidationError> {
  const TitleFormModel.pure() : super.pure('');
  const TitleFormModel.dirty([super.value = '']) : super.dirty();

  @override
  TitleValidationError? validator(String value) {
    if (value.isEmpty) return TitleValidationError.empty;
    return null;
  }
}
