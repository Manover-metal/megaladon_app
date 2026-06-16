part of 'change_password_cubit.dart';

enum ChangePasswordStatus { initial, loading, success, error }

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.oldPassword = const PasswordFormModel.pure(),
    this.password = const PasswordFormModel.pure(),
    this.passwordConfirmation = const PasswordConfirmationFormModel.pure(''),
    this.error,
  });
  final ChangePasswordStatus status;
  final PasswordFormModel oldPassword;
  final PasswordFormModel password;
  final PasswordConfirmationFormModel passwordConfirmation;
  final ErrorModel? error;

  @override
  List<Object?> get props =>
      [status, oldPassword, password, passwordConfirmation, error];

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    PasswordFormModel? oldPassword,
    PasswordFormModel? password,
    PasswordConfirmationFormModel? passwordConfirmation,
    ErrorModel? error,
  }) =>
      ChangePasswordState(
        status: status ?? this.status,
        oldPassword: oldPassword ?? this.oldPassword,
        password: password ?? this.password,
        passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
        error: error ?? this.error,
      );
}
