part of 'register_user_form_cubit.dart';

class RegisterUserFormState extends Equatable {
  const RegisterUserFormState(
      {this.status = false,
      this.name = const NameFormModel.pure(),
      this.phone = const PhoneFormModel.pure(),
      this.password = const PasswordFormModel.pure(),
      this.passwordConfirmation = const PasswordConfirmationFormModel.pure(''),
      this.city = const CityFormModel.pure(),
      this.countTry = 0});
  final bool status;
  final NameFormModel name;
  final PhoneFormModel phone;
  final PasswordFormModel password;
  final PasswordConfirmationFormModel passwordConfirmation;
  final CityFormModel city;
  final int countTry;

  @override
  List<Object?> get props =>
      [status, name, phone, password, passwordConfirmation, city, countTry];

  RegisterUserFormState copyWith(
          {bool? status,
          NameFormModel? name,
          PhoneFormModel? phone,
          PasswordFormModel? password,
          PasswordConfirmationFormModel? passwordConfirmation,
          CityFormModel? city,
          int? countTry}) =>
      RegisterUserFormState(
          status: status ?? this.status,
          name: name ?? this.name,
          phone: phone ?? this.phone,
          password: password ?? this.password,
          passwordConfirmation:
              passwordConfirmation ?? this.passwordConfirmation,
          city: city ?? this.city,
          countTry: countTry ?? this.countTry);
}
