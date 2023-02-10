import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/name.dart';
import 'package:megaladon/data/models/form/password.dart';
import 'package:megaladon/data/models/form/password_confirmation.dart';
import 'package:megaladon/data/models/form/phone.dart';

part 'register_user_form_state.dart';

class RegisterUserFormCubit extends Cubit<RegisterUserFormState> {
  RegisterUserFormCubit() : super(const RegisterUserFormState());

  bool checkRegisterForm({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation
  }) {
    NameFormModel nameForm = NameFormModel.dirty(name);
    PasswordFormModel passwordForm = PasswordFormModel.dirty(password);
    PasswordConfirmationFormModel passwordConfirmationForm = PasswordConfirmationFormModel.dirty(password, passwordConfirmation);
    PhoneFormModel phoneForm = PhoneFormModel.dirty(phone);

    FormzStatus status = Formz.validate([
      passwordForm,
      phoneForm,
      passwordConfirmationForm,
      nameForm
    ]);

    RegisterUserFormState stateNew = state.copyWith(
        name: nameForm,
        phone: phoneForm,
        password: passwordForm,
        passwordConfirmation: passwordConfirmationForm,
        status: status,
    );
    emit(stateNew);
    return stateNew.status.isValid;
  }
}
