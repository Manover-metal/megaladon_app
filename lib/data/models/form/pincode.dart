import 'package:formz/formz.dart';

enum PincodeValidationError {
  empty,
  min;

  @override
  String toString() {
    switch (this) {
      case PincodeValidationError.empty:
        return 'Code is empty';
      case PincodeValidationError.min:
        return 'Code is 6 characters';
    }
  }
}

class PincodeFormModel extends FormzInput<String, PincodeValidationError> {
  const PincodeFormModel.pure() : super.pure('');
  const PincodeFormModel.dirty([super.value = '']) : super.dirty();

  @override
  PincodeValidationError? validator(String value) {
    if (value.isEmpty) {
      return PincodeValidationError.empty;
    } else if (value.length < 6) {
      return PincodeValidationError.min;
    }
    return null;
  }
}
