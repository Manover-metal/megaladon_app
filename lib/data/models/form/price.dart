
import 'package:formz/formz.dart';

enum PriceValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case PriceValidationError.empty:
        return 'Заполните Цену';
    }
  }
}

class PriceFormModel extends FormzInput<String, PriceValidationError> {
  const PriceFormModel.pure() : super.pure('');
  const PriceFormModel.dirty([super.value = '']) : super.dirty();

  @override
  PriceValidationError? validator(String value) {
    if (value.isEmpty) return PriceValidationError.empty;
    return null;
  }
}
