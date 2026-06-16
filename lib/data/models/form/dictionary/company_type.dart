import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum CompanyTypeValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case CompanyTypeValidationError.empty:
        return l10n.form_error_company_type_empty;
    }
  }
}

class CompanyTypeFormModel
    extends FormzInput<int?, CompanyTypeValidationError> {
  const CompanyTypeFormModel.pure() : super.pure(null);
  const CompanyTypeFormModel.dirty([super.value]) : super.dirty();

  @override
  CompanyTypeValidationError? validator(int? value) {
    if (value == null) return CompanyTypeValidationError.empty;
    return null;
  }
}
