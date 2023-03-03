
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

class PriceFormModel extends FormzInput<int?, PriceValidationError> {
  const PriceFormModel.pure() : super.pure(null);
  const PriceFormModel.dirty([super.value]) : super.dirty();

  @override
  PriceValidationError? validator(int? value) {
    if (value == null) return PriceValidationError.empty;
    return null;
  }
}
