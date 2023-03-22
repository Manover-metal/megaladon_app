import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum DescriptionValidationError {
  limit;

  @override
  String toString() {
    switch(this) {
      case DescriptionValidationError.limit:
        return 'Description_exceeds_1000_characters'.tr();
    }
  }
}

class DescriptionFormModel extends FormzInput<String, DescriptionValidationError> {
  const DescriptionFormModel.pure() : super.pure('');
  const DescriptionFormModel.dirty([super.value = '']) : super.dirty();

  @override
  DescriptionValidationError? validator(String value) {
    if(value.length > 1000) return DescriptionValidationError.limit;
    return null;
  }
}
