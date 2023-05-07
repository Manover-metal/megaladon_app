
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum NameValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case NameValidationError.empty:
        return 'Name_is_empty'.tr();
    }
  }
}

class NameFormModel extends FormzInput<String, NameValidationError> {
  const NameFormModel.pure() : super.pure('');
  const NameFormModel.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) return NameValidationError.empty;
    return null;
  }
}
