import 'package:formz/formz.dart';

enum DescriptionValidationError {
  limit;

  @override
  String toString() {
    switch(this) {
      case DescriptionValidationError.limit:
        return 'Описание превысело 1000 символов';
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
