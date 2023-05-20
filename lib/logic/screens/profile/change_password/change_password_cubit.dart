import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/form/password.dart';
import 'package:megaladon/data/models/form/password_confirmation.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final UserRepository _repository = UserRepository();
  final AuthBloc authBloc;
  ChangePasswordCubit(this.authBloc) : super(const ChangePasswordState());


  bool check({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) {
    PasswordFormModel oldPasswordForm = PasswordFormModel.dirty(password);
    PasswordFormModel passwordForm = PasswordFormModel.dirty(password);
    PasswordConfirmationFormModel passwordConfirmationForm = PasswordConfirmationFormModel.dirty(password, passwordConfirmation);

    FormzStatus status = Formz.validate([
      passwordForm,
      passwordConfirmationForm,
      oldPasswordForm
    ]);
    if(!status.isValid) {
      if(passwordForm.invalid) emit(ChangePasswordState(error: ErrorModel([passwordForm.error.toString()]), status: ChangePasswordStatus.error));
      if(passwordConfirmationForm.invalid) emit(ChangePasswordState(error: ErrorModel([passwordConfirmationForm.error.toString()]), status: ChangePasswordStatus.error));
      if(oldPasswordForm.invalid) emit(ChangePasswordState(error: ErrorModel([oldPasswordForm.error.toString()]), status: ChangePasswordStatus.error));
    }

    return status.isValid;
  }

  changePassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    if(state.status == ChangePasswordStatus.loading) return;

    emit(const ChangePasswordState(status: ChangePasswordStatus.loading));
    await _repository.changePassword(
        oldPassword,
        password,
        passwordConfirmation
    ).then((value) {
      print(value);
      emit(const ChangePasswordState(status: ChangePasswordStatus.success));
    }).catchError((error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        }
        emit(ChangePasswordState(error: ErrorModel.parseDio(error), status: ChangePasswordStatus.error));
      } else {
        emit(ChangePasswordState(error: ErrorModel.nothing, status: ChangePasswordStatus.error));
      }
    });

  }
}
