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
  ChangePasswordCubit(this.authBloc) : super(const ChangePasswordState());
  final UserRepository _repository = UserRepository();
  final AuthBloc authBloc;

  bool check({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) {
    var oldPasswordForm = PasswordFormModel.dirty(password);
    var passwordForm = PasswordFormModel.dirty(password);
    var passwordConfirmationForm =
        PasswordConfirmationFormModel.dirty(password, passwordConfirmation);

    final status = Formz.validate(
        [passwordForm, passwordConfirmationForm, oldPasswordForm]);
    if (!status) {
      if (passwordForm.isNotValid)
        emit(ChangePasswordState(
            error: ErrorModel([passwordForm.error.toString()]),
            status: ChangePasswordStatus.error));
      if (passwordConfirmationForm.isNotValid)
        emit(ChangePasswordState(
            error: ErrorModel([passwordConfirmationForm.error.toString()]),
            status: ChangePasswordStatus.error));
      if (oldPasswordForm.isNotValid)
        emit(ChangePasswordState(
            error: ErrorModel([oldPasswordForm.error.toString()]),
            status: ChangePasswordStatus.error));
    }

    return status;
  }

  Future<void> changePassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (state.status == ChangePasswordStatus.loading) return;

    emit(const ChangePasswordState(status: ChangePasswordStatus.loading));
    await _repository
        .changePassword(oldPassword, password, passwordConfirmation)
        .then((value) {
      print(value);
      emit(const ChangePasswordState(status: ChangePasswordStatus.success));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        }
        emit(ChangePasswordState(
            error: ErrorModel.parseDio(error),
            status: ChangePasswordStatus.error));
      } else {
        emit(ChangePasswordState(
            error: ErrorModel.nothing, status: ChangePasswordStatus.error));
      }
    });
  }
}
