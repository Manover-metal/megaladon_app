
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum LonValidationError {
  empty, min, max;

  @override
  String toString() {
    switch(this) {
      case LonValidationError.empty:
        return 'Longitude_is_not_filled'.tr();
      case LonValidationError.min:
        return 'Longitude_cannot_be_less_than_180'.tr();
      case LonValidationError.max:
        return 'Longitude_cannot_be_greater_than_180'.tr();
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
