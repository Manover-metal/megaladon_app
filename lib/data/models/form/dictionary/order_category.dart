import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum OrderCategoryValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case OrderCategoryValidationError.empty:
        return l10n.form_error_order_category_empty;
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
