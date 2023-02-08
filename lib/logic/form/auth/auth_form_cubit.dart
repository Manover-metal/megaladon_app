import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/email.dart';
import 'package:megaladon/data/models/form/password.dart';
import 'package:megaladon/data/models/form/phone.dart';

part 'auth_form_state.dart';

class AuthFormCubit extends Cubit<AuthFormState> {
  AuthFormCubit() : super(const AuthFormState());

  changeEmail(String email) {
    PhoneFormModel phoneForm = PhoneFormModel.dirty(email);
    emit(state.copyWith(
      phone: phoneForm,
      status: Formz.validate([
        phoneForm,
        state.password
      ])
    ));
  }

  changePassword(String password) {
    PasswordFormModel passwordForm = PasswordFormModel.dirty(password);
    emit(state.copyWith(
        password: passwordForm,
        status: Formz.validate([
          state.phone,
          passwordForm
        ])
    ));
  }
}
