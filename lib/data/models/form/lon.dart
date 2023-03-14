
import 'package:formz/formz.dart';

enum LonValidationError {
  empty, min, max;

  @override
  String toString() {
    switch(this) {
      case LonValidationError.empty:
        return 'Долгота не заполнен';
      case LonValidationError.min:
        return 'Долгота не может быть меньше -180°';
      case LonValidationError.max:
        return 'Долгота не может быть больше 180°';
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
