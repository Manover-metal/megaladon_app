part of 'change_phone_cubit.dart';

enum ChangePhoneStatus {
  initial,
  loading,
  success,
  error,
  initial2,
  loading2,
  success2,
  error2
}

class ChangePhoneState extends Equatable {
  const ChangePhoneState({
    this.status = ChangePhoneStatus.initial,
    this.phone = const PhoneFormModel.pure(),
    this.password = const PasswordFormModel.pure(),
    this.code = const PincodeFormModel.pure(),
    this.error,
  });
  final ChangePhoneStatus status;
  final PhoneFormModel phone;
  final PasswordFormModel password;
  final PincodeFormModel code;
  final ErrorModel? error;

  @override
  List<Object?> get props => [status, phone, password, code, error];

  ChangePhoneState copyWith({
    ChangePhoneStatus? status,
    PhoneFormModel? phone,
    PasswordFormModel? password,
    PincodeFormModel? code,
    ErrorModel? error,
  }) =>
      ChangePhoneState(
        status: status ?? this.status,
        phone: phone ?? this.phone,
        password: password ?? this.password,
        code: code ?? this.code,
        error: error ?? this.error,
      );
}
