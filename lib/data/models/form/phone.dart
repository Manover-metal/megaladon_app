import 'package:formz/formz.dart';

enum PhoneValidationError {
  empty;

  @override
  String toString() {
    switch (this) {
      case PhoneValidationError.empty:
        return 'Phone number is empty';
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
