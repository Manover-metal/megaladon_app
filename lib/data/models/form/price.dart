import 'package:formz/formz.dart';

enum PriceValidationError {
  empty;

  @override
  String toString() {
    switch (this) {
      case PriceValidationError.empty:
        return 'Fill in the price';
    }
  }
}

class PriceFormModel extends FormzInput<String, PriceValidationError> {
  const PriceFormModel.pure([this.isRequired = true]) : super.pure('');
  const PriceFormModel.dirty([super.value = '', this.isRequired = true])
      : super.dirty();
  final bool isRequired;

  @override
  PriceValidationError? validator(String value) {
    if (value.isEmpty && isRequired) return PriceValidationError.empty;
    return null;
  }
}
