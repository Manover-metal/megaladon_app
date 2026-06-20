import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum ExecutionDaysValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case ExecutionDaysValidationError.empty:
        return l10n.form_error_execution_days_empty;
    }
  }
}

class ExecutionDaysFormModel
    extends FormzInput<String, ExecutionDaysValidationError> {
  const ExecutionDaysFormModel.pure() : super.pure('');
  const ExecutionDaysFormModel.dirty([super.value = '']) : super.dirty();

  @override
  ExecutionDaysValidationError? validator(String value) {
    if (value.isEmpty) {
      return ExecutionDaysValidationError.empty;
    }
    return null;
  }
}
