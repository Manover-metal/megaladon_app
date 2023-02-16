part of 'auth_form_cubit.dart';

class AuthFormState extends Equatable {
  final FormzStatus status;
  final PhoneFormModel phone;
  final PasswordFormModel password;
  final int countTry;

  const AuthFormState({
    this.status = FormzStatus.pure,
    this.phone = const PhoneFormModel.dirty(''),
    this.password = const PasswordFormModel.dirty(''),
    this.countTry = 0
  });

  @override
  List<Object?> get props => [status, phone, password];

  AuthFormState copyWith ({
    FormzStatus? status,
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
