import 'package:formz/formz.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';

enum ServiceTypeValidationError {
  empty;

  @override
  String toString() {
    switch (this) {
      case ServiceTypeValidationError.empty:
        return 'Type is not specified';
    }
  }
}

class ServiceTypeFormModel extends FormzInput<int, ServiceTypeValidationError> {
  const ServiceTypeFormModel.pure() : super.pure(-1);
  const ServiceTypeFormModel.dirty([super.value = -1]) : super.dirty();

  @override
  ServiceTypeValidationError? validator(int value) {
    if (value == ServiceTypeModel.nothing.id)
      return ServiceTypeValidationError.empty;
    return null;
  }
}
