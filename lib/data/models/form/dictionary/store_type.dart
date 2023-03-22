import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';

enum StoreTypeValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case StoreTypeValidationError.empty:
        return 'Type_is_not_specified'.tr();
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
