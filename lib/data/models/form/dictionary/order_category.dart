import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';

enum OrderCategoryValidationError {
  empty;

  @override
  String toString() {
    switch (this) {
      case OrderCategoryValidationError.empty:
        return 'Category is not filled out';
    }
  }
}

class OrderCategoryFormModel
    extends FormzInput<int, OrderCategoryValidationError> {
  const OrderCategoryFormModel.pure() : super.pure(-1);
  const OrderCategoryFormModel.dirty([super.value = -1]) : super.dirty();

  @override
  OrderCategoryValidationError? validator(int value) {
    if (value == OrderCategoryModel.nothing.id)
      return OrderCategoryValidationError.empty;
    return null;
  }
}
