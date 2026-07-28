part of 'password_recovery_cubit.dart';

enum PasswordRecoveryStatus {
  initial,
  loading,
  success,
  error,
  initial2,
  loading2,
  success2,
  error2,
}

class PasswordRecoveryState extends Equatable {
  const PasswordRecoveryState({
    this.status = PasswordRecoveryStatus.initial,
    this.phone = const PhoneFormModel.pure(),
    this.code = const PincodeFormModel.pure(),
    this.password = const PasswordFormModel.pure(),
    this.passwordConfirmation = const PasswordConfirmationFormModel.pure(''),
    this.error,
  });

  final PasswordRecoveryStatus status;
  final PhoneFormModel phone;
  final PincodeFormModel code;
  final PasswordFormModel password;
  final PasswordConfirmationFormModel passwordConfirmation;
  final ErrorModel? error;

  @override
  List<Object?> get props =>
      [status, phone, code, password, passwordConfirmation, error];

  PasswordRecoveryState copyWith({
    PasswordRecoveryStatus? status,
    PhoneFormModel? phone,
    PincodeFormModel? code,
    PasswordFormModel? password,
    PasswordConfirmationFormModel? passwordConfirmation,
    ErrorModel? error,
  }) =>
      PasswordRecoveryState(
        status: status ?? this.status,
        phone: phone ?? this.phone,
        code: code ?? this.code,
        password: password ?? this.password,
        passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
        error: error ?? this.error,
      );
}
