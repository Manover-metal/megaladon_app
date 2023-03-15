
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/contact_model.dart';

enum MultiContactValidationError {
  empty, dataEmpty;

  @override
  String toString() {
    switch(this) {
      case MultiContactValidationError.empty:
        return 'Добавьте минимум один контакт';
      case MultiContactValidationError.dataEmpty:
        return 'Контакты не полностью заполнены';
    }
  }
}

class MultiContactFormModel extends FormzInput<List<ContactModel>, MultiContactValidationError> {
  const MultiContactFormModel.pure() : super.pure(const []);
  const MultiContactFormModel.dirty([super.value = const []]) : super.dirty();

  @override
  MultiContactValidationError? validator(List<ContactModel> value) {
    if (value.isEmpty) {
      print('a');
      return MultiContactValidationError.empty;
    }
    print('b');
    for(var element in value) {
      if(element.type == ContactType.home_phone || element.type == ContactType.phone
         && element.value.isEmpty || element.contactName!.isEmpty) {
        return MultiContactValidationError.dataEmpty;
      } else if(element.value.isEmpty) {
        return MultiContactValidationError.dataEmpty;
      }
    }

    return null;
  }
}
