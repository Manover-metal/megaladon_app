part of 'register_user_form_cubit.dart';

class RegisterUserFormState extends Equatable {
  final FormzStatus status;
  final NameFormModel name;
  final PhoneFormModel phone;
  final PasswordFormModel password;
  final PasswordConfirmationFormModel passwordConfirmation;
  final int countTry;

  const RegisterUserFormState({
    this.status = FormzStatus.pure,
    this.name = const NameFormModel.pure(),
    this.phone = const PhoneFormModel.pure(),
    this.password = const PasswordFormModel.pure(),
    this.passwordConfirmation = const PasswordConfirmationFormModel.pure(''),
    this.countTry = 0
  });

  @override
  List<Object?> get props => [status, name, phone, password, passwordConfirmation, countTry];

  RegisterUserFormState copyWith ({
    FormzStatus? status,
    NameFormModel? name,
    PhoneFormModel? phone,
    PasswordFormModel? password,
    PasswordConfirmationFormModel? passwordConfirmation,
    int? countTry
  }) {
    return RegisterUserFormState(
        status: status ?? this.status,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        password: password ?? this.password,
        passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
        countTry: countTry ?? this.countTry
    );
  }
}

