
import 'package:formz/formz.dart';

enum LatValidationError {
  empty, min, max;

  @override
  String toString() {
    switch(this) {
      case LatValidationError.empty:
        return 'Широта не заполнен';
      case LatValidationError.min:
        return 'Широта не может быть меньше -90°';
      case LatValidationError.max:
        return 'Широта не может быть больше +90°';
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
