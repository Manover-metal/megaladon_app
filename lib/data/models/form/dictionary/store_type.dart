import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';

enum StoreTypeValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case StoreTypeValidationError.empty:
        return 'Тип не указан';
    }
  }
}

class StoreTypeFormModel extends FormzInput<int, StoreTypeValidationError> {
  const StoreTypeFormModel.pure() : super.pure(-1);
  const StoreTypeFormModel.dirty([super.value = -1]) : super.dirty();


  @override
  StoreTypeValidationError? validator(int value) {
    if (value == StoreTypeModel.nothing.id) return StoreTypeValidationError.empty;
    return null;
  }
}
