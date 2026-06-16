part of 'auth_form_cubit.dart';

class AuthFormState extends Equatable {
  const AuthFormState(
      {this.status = false,
      this.phone = const PhoneFormModel.pure(),
      this.password = const PasswordFormModel.pure(),
      this.countTry = 0});
  final bool status;
  final PhoneFormModel phone;
  final PasswordFormModel password;
  final int countTry;

  @override
  List<Object?> get props => [status, phone, password, countTry];

  AuthFormState copyWith(
          {bool? status,
          PhoneFormModel? phone,
          PasswordFormModel? password,
          int? countTry}) =>
      AuthFormState(
          status: status ?? this.status,
          phone: phone ?? this.phone,
          password: password ?? this.password,
          countTry: countTry ?? this.countTry);
}
