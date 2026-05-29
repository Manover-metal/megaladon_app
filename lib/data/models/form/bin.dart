import 'package:formz/formz.dart';

enum BinValidationError {
  empty,
  min,
  max;

  @override
  String toString() {
    switch (this) {
      case BinValidationError.empty:
        return 'BIN/IIN is not filled';
      case BinValidationError.min:
        return 'BIN/INN is not fully filled';
      case BinValidationError.max:
        return 'BIN/INN maximum 12 digits';
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
    } else if (value.length < 12) {
      return BinValidationError.min;
    } else if (value.length >= 13) {
      return BinValidationError.max;
    }
    return null;
  }
}
