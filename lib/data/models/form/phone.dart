import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum PhoneValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case PhoneValidationError.empty:
        return l10n.form_error_phone_empty;
    }
  }
}

class PhoneFormModel extends FormzInput<String, PhoneValidationError> {
  const PhoneFormModel.pure([this.isRequired = true]) : super.pure('');
  const PhoneFormModel.dirty([super.value = '', this.isRequired = true])
      : super.dirty();
  final bool isRequired;

  @override
  PhoneValidationError? validator(String value) {
    if (value.isEmpty && isRequired) {
      return PhoneValidationError.empty;
    }
    return null;
  }
}
