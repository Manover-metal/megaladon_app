import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';

enum AdvertCategoryValidationError {
  empty;

  @override
  String toString() {
    switch (this) {
      case AdvertCategoryValidationError.empty:
        return 'Select category';
    }
  }
}

class AdvertCategoryFormModel
    extends FormzInput<int, AdvertCategoryValidationError> {
  const AdvertCategoryFormModel.pure() : super.pure(-1);
  const AdvertCategoryFormModel.dirty([super.value = -1]) : super.dirty();

  @override
  AdvertCategoryValidationError? validator(int value) {
    if (value == AdvertCategoryModel.nothing.id)
      return AdvertCategoryValidationError.empty;
    return null;
  }
}
