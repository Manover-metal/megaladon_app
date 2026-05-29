import 'package:formz/formz.dart';
import 'package:megaladon/data/models/contact_model.dart';

enum MultiContactValidationError {
  empty,
  dataEmpty;

  @override
  String toString() {
    switch (this) {
      case MultiContactValidationError.empty:
        return 'Add at least one contact';
      case MultiContactValidationError.dataEmpty:
        return 'Contacts are not fully filled out';
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
      print(element.type);
    }

    return null;
  }
}
