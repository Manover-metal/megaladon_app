
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/contact_model.dart';

enum MultiContactValidationError {
  empty, dataEmpty;

  @override
  String toString() {
    switch(this) {
      case MultiContactValidationError.empty:
        return 'Add_at_least_one_contact'.tr();
      case MultiContactValidationError.dataEmpty:
        return 'Contacts_are_not_fully_filled_out'.tr();
    }
  }
}

class MultiContactFormModel extends FormzInput<List<ContactModel>, MultiContactValidationError> {
  const MultiContactFormModel.pure() : super.pure(const []);
  const MultiContactFormModel.dirty([super.value = const []]) : super.dirty();

  @override
  MultiContactValidationError? validator(List<ContactModel> value) {
    if (value.isEmpty) {
      return MultiContactValidationError.empty;
    }
    for(var element in value) {
      if(element.type == ContactType.home_phone || element.type == ContactType.phone) {
        if(element.value.isEmpty || element.contactName!.isEmpty) {
          return MultiContactValidationError.dataEmpty;
        }
      } else if(element.value.isEmpty) {
        return MultiContactValidationError.dataEmpty;
      }
      print(element.type);

    }

    return null;
  }
}
