part of 'auth_form_cubit.dart';

class AuthFormState extends Equatable {
  final bool status;
  final PhoneFormModel phone;
  final PasswordFormModel password;
  final int countTry;

  const AuthFormState({
    this.status = false,
    this.phone = const PhoneFormModel.dirty(''),
    this.password = const PasswordFormModel.dirty(''),
    this.countTry = 0
  });

  @override
  List<Object?> get props => [status, phone, password, countTry];

  AuthFormState copyWith ({
    bool? status,
    PhoneFormModel? phone,
    PasswordFormModel? password,
    int? countTry
  }) {
    return AuthFormState(
        status: status ?? this.status,
        phone: phone ?? this.phone,
        password: password ?? this.password,
        countTry: countTry ?? this.countTry
    );
  }
}
