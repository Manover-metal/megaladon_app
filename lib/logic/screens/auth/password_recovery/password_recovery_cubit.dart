import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/core/locale_storage/secure_locale_storage.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/form/password.dart';
import 'package:megaladon/data/models/form/password_confirmation.dart';
import 'package:megaladon/data/models/form/phone.dart';
import 'package:megaladon/data/models/form/pincode.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';

part 'password_recovery_state.dart';

class PasswordRecoveryCubit extends Cubit<PasswordRecoveryState> {
  PasswordRecoveryCubit() : super(const PasswordRecoveryState());

  final AuthRepository _repository =
      AuthRepository(localeStorage: SecureLocaleStorageImpl());

  bool checkStep1({required String phone}) {
    final phoneForm = PhoneFormModel.dirty(phone);
    final status = Formz.validate([phoneForm]);

    emit(state.copyWith(
      phone: phoneForm,
      status: PasswordRecoveryStatus.initial,
    ));

    return status;
  }

  bool checkStep2({
    required String code,
    required String password,
    required String passwordConfirmation,
  }) {
    final codeForm = PincodeFormModel.dirty(code);
    final passwordForm = PasswordFormModel.dirty(password);
    final passwordConfirmationForm =
        PasswordConfirmationFormModel.dirty(password, passwordConfirmation);

    final status = Formz.validate(
        [codeForm, passwordForm, passwordConfirmationForm]);

    emit(state.copyWith(
      code: codeForm,
      password: passwordForm,
      passwordConfirmation: passwordConfirmationForm,
      status: PasswordRecoveryStatus.initial2,
    ));

    return status;
  }

  Future<void> sendCode({required String phone}) async {
    if (state.status == PasswordRecoveryStatus.loading) return;

    emit(state.copyWith(status: PasswordRecoveryStatus.loading));
    await _repository.forgotPassword(phone: phone).then((value) {
      emit(state.copyWith(status: PasswordRecoveryStatus.success));
    }).catchError((Object error) {
      if (error is DioException) {
        emit(state.copyWith(
          error: ErrorModel.parseDio(error),
          status: PasswordRecoveryStatus.error,
        ));
      } else {
        emit(state.copyWith(
          error: ErrorModel.nothing,
          status: PasswordRecoveryStatus.error,
        ));
      }
    });
  }

  Future<void> resetPassword({
    required String phone,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (state.status == PasswordRecoveryStatus.loading2) return;

    emit(state.copyWith(status: PasswordRecoveryStatus.loading2));
    await _repository
        .resetPassword(
      phone: phone,
      code: code,
      password: password,
      passwordConfirmation: passwordConfirmation,
    )
        .then((value) {
      emit(state.copyWith(status: PasswordRecoveryStatus.success2));
    }).catchError((Object error) {
      if (error is DioException) {
        emit(state.copyWith(
          error: ErrorModel.parseDio(error),
          status: PasswordRecoveryStatus.error2,
        ));
      } else {
        emit(state.copyWith(
          error: ErrorModel.nothing,
          status: PasswordRecoveryStatus.error2,
        ));
      }
    });
  }
}
