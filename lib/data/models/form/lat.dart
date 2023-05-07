
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum LatValidationError {
  empty, min, max;

  @override
  String toString() {
    switch(this) {
      case LatValidationError.empty:
        return 'Latitude_not_filled'.tr();
      case LatValidationError.min:
        return 'Latitude_cannot_be_less_than_90'.tr();
      case LatValidationError.max:
        return 'Latitude_cannot_be_greater_than_90'.tr();
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
