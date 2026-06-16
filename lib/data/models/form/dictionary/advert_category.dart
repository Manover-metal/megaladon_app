import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum AdvertCategoryValidationError implements LocalizableError {
  empty;

  @override
  String localize(AppLocalizations l10n) {
    switch (this) {
      case AdvertCategoryValidationError.empty:
        return l10n.form_error_advert_category_empty;
    }
  }
}

class AdvertCategoryFormModel
    extends FormzInput<int?, AdvertCategoryValidationError> {
  const AdvertCategoryFormModel.pure() : super.pure(null);
  const AdvertCategoryFormModel.dirty([super.value]) : super.dirty();

  @override
  AdvertCategoryValidationError? validator(int? value) {
    if (value == null || value == AdvertCategoryModel.nothing.id)
      return AdvertCategoryValidationError.empty;
    return null;
  }
}
