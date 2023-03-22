
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';

enum OrderCategoryValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case OrderCategoryValidationError.empty:
        return 'Category_is_not_filled_out'.tr();
    }
  }
}

class OrderCategoryFormModel extends FormzInput<int, OrderCategoryValidationError> {
  const OrderCategoryFormModel.pure() : super.pure(-1);
  const OrderCategoryFormModel.dirty([super.value = -1]) : super.dirty();


  @override
  OrderCategoryValidationError? validator(int value) {
    if (value == OrderCategoryModel.nothing.id) return OrderCategoryValidationError.empty;
    return null;
  }
}
