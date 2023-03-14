
import 'package:formz/formz.dart';

enum LatLonValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case LatLonValidationError.empty:
        return 'Широта или Долгота не заполнен';
    }
  }
}

class LatLonFormModel extends FormzInput<String, LatLonValidationError> {
  const LatLonFormModel.pure() : super.pure('');
  const LatLonFormModel.dirty([super.value = '']) : super.dirty();

  @override
  LatLonValidationError? validator(String value) {
    if (value.isEmpty) {
      return LatLonValidationError.empty;
    }
    return null;
  }
}
