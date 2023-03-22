
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum BinValidationError {
  empty, min, max;

  @override
  String toString() {
    switch(this) {
      case BinValidationError.empty:
        return 'BIN_is_not_filled'.tr();
      case BinValidationError.min:
        return 'BIN_is_not_fully_filled'.tr();
      case BinValidationError.max:
        return 'BIN_maximum_12_digits'.tr();

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
    }else if (value.length >= 13) {
      return BinValidationError.max;
    }
    return null;
  }
}
