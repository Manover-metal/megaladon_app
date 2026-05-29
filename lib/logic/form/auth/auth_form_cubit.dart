import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/password.dart';
import 'package:megaladon/data/models/form/phone.dart';

part 'auth_form_state.dart';

class AuthFormCubit extends Cubit<AuthFormState> {
  AuthFormCubit() : super(const AuthFormState());

  bool checkLogin({
    required String phone,
    required String password,
  }) {
    var passwordForm = PasswordFormModel.dirty(password);
    var phoneForm = PhoneFormModel.dirty(phone);

    var status = Formz.validate([
      passwordForm,
      phoneForm,
    ]);

    var stateNew = state.copyWith(
        phone: phoneForm,
        password: passwordForm,
        status: status,
        countTry: state.countTry + 1);
    emit(stateNew);
    return stateNew.status;
  }
}
