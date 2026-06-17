import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/dictionary/city.dart';
import 'package:megaladon/data/models/form/name.dart';
import 'package:megaladon/data/models/form/password.dart';
import 'package:megaladon/data/models/form/password_confirmation.dart';
import 'package:megaladon/data/models/form/phone.dart';

part 'register_user_form_state.dart';

class RegisterUserFormCubit extends Cubit<RegisterUserFormState> {
  RegisterUserFormCubit() : super(const RegisterUserFormState());

  bool checkRegisterForm(
      {required String name,
      required String phone,
      required String password,
      required String passwordConfirmation,
      required int? city}) {
    var nameForm = NameFormModel.dirty(name);
    var passwordForm = PasswordFormModel.dirty(password);
    var passwordConfirmationForm =
        PasswordConfirmationFormModel.dirty(password, passwordConfirmation);
    var phoneForm = PhoneFormModel.dirty(phone);
    var cityForm = CityFormModel.dirty(city);

    var status = Formz.validate(
        [passwordForm, phoneForm, passwordConfirmationForm, nameForm, cityForm]);

    var stateNew = state.copyWith(
        name: nameForm,
        phone: phoneForm,
        password: passwordForm,
        passwordConfirmation: passwordConfirmationForm,
        city: cityForm,
        status: status,
        countTry: state.countTry + 1);
    emit(stateNew);
    return stateNew.status;
  }
}
