import 'package:formz/formz.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum MultiContactValidationError implements LocalizableError {
  empty,
  dataEmpty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case MultiContactValidationError.empty:
        return l10n.form_error_contacts_empty;
      case MultiContactValidationError.dataEmpty:
        return l10n.form_error_contacts_incomplete;
    }
  }
}

class MultiContactFormModel
    extends FormzInput<List<ContactModel>, MultiContactValidationError> {
  const MultiContactFormModel.pure() : super.pure(const []);
  const MultiContactFormModel.dirty([super.value = const []]) : super.dirty();

  @override
  MultiContactValidationError? validator(List<ContactModel> value) {
    if (value.isEmpty) {
      return MultiContactValidationError.empty;
    }
    for (final element in value) {
      if (element.type == ContactType.home_phone ||
          element.type == ContactType.phone) {
        if (element.value.isEmpty || element.contactName!.isEmpty) {
          return MultiContactValidationError.dataEmpty;
        }
      } else if (element.value.isEmpty) {
        return MultiContactValidationError.dataEmpty;
      }
    }

    return null;
  }
}
