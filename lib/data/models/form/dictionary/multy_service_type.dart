import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum MultiServiceTypeValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case MultiServiceTypeValidationError.empty:
        return l10n.form_error_services_empty;
    }
  }
}

class MultiServiceTypeFormModel extends FormzInput<List<ServiceTypeModel>,
    MultiServiceTypeValidationError> {
  const MultiServiceTypeFormModel.pure() : super.pure(const []);
  const MultiServiceTypeFormModel.dirty([super.value = const []])
      : super.dirty();

  @override
  MultiServiceTypeValidationError? validator(List<ServiceTypeModel> value) {
    if (value.isEmpty) {
      return MultiServiceTypeValidationError.empty;
    }

    return null;
  }
}
