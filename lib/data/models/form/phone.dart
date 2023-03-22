
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum PhoneValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case PhoneValidationError.empty:
        return 'Phone_number_is_empty'.tr();
    }
  }
}

class PhoneFormModel extends FormzInput<String, PhoneValidationError> {
  const PhoneFormModel.pure() : super.pure('');
  const PhoneFormModel.dirty([super.value = '']) : super.dirty();

  @override
  PhoneValidationError? validator(String value) {
    if (value.isEmpty) {
      return PhoneValidationError.empty;
    }
    return null;
  }
}
