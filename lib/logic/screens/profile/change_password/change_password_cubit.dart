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
    var oldPasswordForm = PasswordFormModel.dirty(oldPassword);
    var passwordForm = PasswordFormModel.dirty(password);
    var passwordConfirmationForm =
        PasswordConfirmationFormModel.dirty(password, passwordConfirmation);

    final status = Formz.validate(
        [passwordForm, passwordConfirmationForm, oldPasswordForm]);

    emit(state.copyWith(
      oldPassword: oldPasswordForm,
      password: passwordForm,
      passwordConfirmation: passwordConfirmationForm,
      status: ChangePasswordStatus.initial,
    ));

    return status;
  }

  Future<void> changePassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (state.status == ChangePasswordStatus.loading) return;

    emit(state.copyWith(status: ChangePasswordStatus.loading));
    await _repository
        .changePassword(oldPassword, password, passwordConfirmation)
        .then((value) {
      emit(state.copyWith(status: ChangePasswordStatus.success));
    }).catchError((Object error) {
      if (error is DioException) {
        if (error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        }
        emit(state.copyWith(
            error: ErrorModel.parseDio(error),
            status: ChangePasswordStatus.error));
      } else {
        emit(state.copyWith(
            error: ErrorModel.nothing, status: ChangePasswordStatus.error));
      }
    });
  }
}
