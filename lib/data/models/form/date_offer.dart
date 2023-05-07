
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum DateOfferValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case DateOfferValidationError.empty:
        return 'Work_time_is_not_filled'.tr();
    }
  }
}

class DateOfferFormModel extends FormzInput<String, DateOfferValidationError> {
  const DateOfferFormModel.pure() : super.pure('');
  const DateOfferFormModel.dirty([super.value = '']) : super.dirty();

  @override
  DateOfferValidationError? validator(String value) {
    if (value.isEmpty) {
      return DateOfferValidationError.empty;
    }
    return null;
  }
}
