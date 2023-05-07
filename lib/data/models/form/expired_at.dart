
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum ExpiredAtValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case ExpiredAtValidationError.empty:
        return 'Response_relevance_is_not_filled'.tr();
    }
  }
}

class ExpiredAtFormModel extends FormzInput<String, ExpiredAtValidationError> {
  const ExpiredAtFormModel.pure() : super.pure('');
  const ExpiredAtFormModel.dirty([super.value = '']) : super.dirty();

  @override
  ExpiredAtValidationError? validator(String value) {
    if (value.isEmpty) {
      return ExpiredAtValidationError.empty;
    }
    return null;
  }
}
