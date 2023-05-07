
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';

enum PriceValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case PriceValidationError.empty:
        return 'Fill_in_the_price'.tr();
    }
  }
}

class PriceFormModel extends FormzInput<String, PriceValidationError> {
  final bool isRequired;
  const PriceFormModel.pure([this.isRequired = true]) : super.pure('');
  const PriceFormModel.dirty([super.value = '', this.isRequired = true]) : super.dirty();

  @override
  PriceValidationError? validator(String value) {
    if (value.isEmpty && isRequired) return PriceValidationError.empty;
    return null;
  }
}
