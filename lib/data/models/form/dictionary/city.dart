
import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';

enum CityValidationError {
  empty;

  @override
  String toString() {
    switch(this) {
      case CityValidationError.empty:
        return 'Select_city'.tr();
    }
  }
}

class CityFormModel extends FormzInput<int, CityValidationError> {
  const CityFormModel.pure() : super.pure(-1);
  const CityFormModel.dirty([super.value = -1]) : super.dirty();


  @override
  CityValidationError? validator(int value) {
    if (value == CityModel.nothing.id) return CityValidationError.empty;
    return null;
  }
}
