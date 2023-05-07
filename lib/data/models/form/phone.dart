
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
  final bool isRequired;
  const PhoneFormModel.pure([this.isRequired = true]) : super.pure('');
  const PhoneFormModel.dirty([super.value = '', this.isRequired = true]) : super.dirty();

  @override
  PhoneValidationError? validator(String value) {
    if (value.isEmpty && isRequired) {
      return PhoneValidationError.empty;
    }
    return null;
  }
}
