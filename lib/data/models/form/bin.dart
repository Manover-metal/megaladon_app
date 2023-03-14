
import 'package:formz/formz.dart';

enum BinValidationError {
  empty, min;

  @override
  String toString() {
    switch(this) {
      case BinValidationError.empty:
        return 'БИН не заполнен';
      case BinValidationError.min:
        return 'БИН не полностью заполнен';
    }
  }
}

class BinFormModel extends FormzInput<String, BinValidationError> {
  const BinFormModel.pure() : super.pure('');
  const BinFormModel.dirty([super.value = '']) : super.dirty();

  @override
  BinValidationError? validator(String value) {
    if (value.isEmpty) {
      return BinValidationError.empty;
    } else if (value.length > 12) {
      return BinValidationError.min;
    }
    return null;
  }
}
