import 'package:formz/formz.dart';

enum LonValidationError {
  empty,
  min,
  max;

  @override
  String toString() {
    switch (this) {
      case LonValidationError.empty:
        return 'Longitude is not filled';
      case LonValidationError.min:
        return 'Longitude cannot be less than -180°';
      case LonValidationError.max:
        return 'Longitude cannot be greater than 180°';
    }
  }
}

class LonFormModel extends FormzInput<String, LonValidationError> {
  const LonFormModel.pure() : super.pure('');
  const LonFormModel.dirty([super.value = '']) : super.dirty();

  @override
  LonValidationError? validator(String value) {
    if (value.isEmpty) {
      return LonValidationError.empty;
    } else if (double.parse(value) < -180) {
      return LonValidationError.min;
    } else if (double.parse(value) > 180) {
      return LonValidationError.max;
    }
    return null;
  }
}
