
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum TitleValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case TitleValidationError.empty:
        return 'Header_is_empty'.tr();
    }
  }
}

class TitleFormModel extends FormzInput<String, TitleValidationError> {
  const TitleFormModel.pure() : super.pure('');
  const TitleFormModel.dirty([super.value = '']) : super.dirty();

  @override
  TitleValidationError? validator(String value) {
    if (value.isEmpty) return TitleValidationError.empty;
    return null;
  }
}
