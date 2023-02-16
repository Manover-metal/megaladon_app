import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/email.dart';
import 'package:megaladon/data/models/form/password.dart';
import 'package:megaladon/data/models/form/phone.dart';

part 'auth_form_state.dart';

class AuthFormCubit extends Cubit<AuthFormState> {
  AuthFormCubit() : super(const AuthFormState());

  checkLogin({
    required String phone,
    required String password,
  }) {
    PasswordFormModel passwordForm = PasswordFormModel.dirty(password);
    PhoneFormModel phoneForm = PhoneFormModel.dirty(phone);

    FormzStatus status = Formz.validate([
      passwordForm,
      phoneForm,
    ]);

    AuthFormState stateNew = state.copyWith(
        phone: phoneForm,
        password: passwordForm,
        status: status,
        countTry: state.countTry + 1
    );
    emit(stateNew);
    return stateNew.status.isValid;
  }
}
