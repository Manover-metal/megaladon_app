import 'package:formz/formz.dart';

enum DateOfferValidationError {
  empty;

  @override
  String toString() {
    switch (this) {
      case DateOfferValidationError.empty:
        return 'Work time is not filled';
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
