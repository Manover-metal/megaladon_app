import 'package:formz/formz.dart';

enum LatValidationError {
  empty,
  min,
  max;

  @override
  String toString() {
    switch (this) {
      case LatValidationError.empty:
        return 'Latitude is not filled';
      case LatValidationError.min:
        return 'Latitude cannot be less than -90°';
      case LatValidationError.max:
        return 'Latitude cannot be greater than +90°';
    }
  }
}

class LatFormModel extends FormzInput<String, LatValidationError> {
  const LatFormModel.pure() : super.pure('');
  const LatFormModel.dirty([super.value = '']) : super.dirty();

  @override
  LatValidationError? validator(String value) {
    if (value.isEmpty) {
      return LatValidationError.empty;
    } else if (double.parse(value) < -90) {
      return LatValidationError.min;
    } else if (double.parse(value) > 90) {
      return LatValidationError.max;
    }
    return null;
  }
}
