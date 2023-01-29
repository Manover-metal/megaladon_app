import 'package:formz/formz.dart';

enum DescriptionValidationError { limit }

class DescriptionFormModel extends FormzInput<String, DescriptionValidationError> {
  const DescriptionFormModel.pure() : super.pure('');
  const DescriptionFormModel.dirty([super.value = '']) : super.dirty();

  @override
  DescriptionValidationError? validator(String value) {
    if(value.length > 1000) return DescriptionValidationError.limit;
    return null;
  }
}
