import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/params/register/register_user_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/register/register_user/register_user_form_cubit.dart';
import 'package:megaladon/logic/register/register_user/register_user_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/auth/auth_scaffold.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/password_field.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/user_agreement_text.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordVerifyController;
  late CityPickerController _cityController;

  bool _checkForm() {
    var form = context.read<RegisterUserFormCubit>();
    return form.checkRegisterForm(
        name: _nameController.value.text,
        phone: _phoneController.value.text,
        password: _passwordController.value.text,
        passwordConfirmation: _passwordVerifyController.value.text,
        city: _cityController.value?.id);
  }

  // Ошибки полей рисуются под полями. Снекбар остаётся за ответом сервера.
  void _listenRegister(BuildContext context, RegisterUserState state) {
    if (state is RegisterUserSuccess) {
      var phone = context.read<RegisterUserFormCubit>().state.phone.value;
      // push, а не replace: с экрана подтверждения можно вернуться и
      // поправить номер, не набирая форму заново.
      context.router.push(VerifyRoute(phone: phone));
    } else if (state is RegisterUserError) {
      CustomSnackBar.error(
        Text(
          state.error.messages.isNotEmpty
              ? state.error.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    }
  }

  void _register() {
    if (_checkForm()) {
      context.read<RegisterUserBloc>().add(RegisterUserFetchEvent(
          RegisterUserRequestParams(
              name: _nameController.value.text,
              phone: _phoneController.value.text,
              password: _passwordController.value.text,
              passwordConfirmation: _passwordVerifyController.value.text,
              city: _cityController.value!)));
    }
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _phoneController = TextEditingController(text: '+7');
    _passwordController = TextEditingController();
    _passwordVerifyController = TextEditingController();
    _cityController = CityPickerController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordVerifyController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<RegisterUserBloc, RegisterUserState>(
      listener: _listenRegister,
      child: AuthScaffold(
        title: l10n.registration,
        footer: const UserAgreementText(),
        children: [
          AuthHeading(
            title: l10n.registration,
            subtitle: l10n.register_user_subtitle,
          ),
          const SizedBox(height: 20),
          BlocBuilder<RegisterUserFormCubit, RegisterUserFormState>(
            builder: (context, formState) => AuthFieldGroup(
              children: [
                TextFieldApp(
                  label: l10n.what_is_your_name,
                  controller: _nameController,
                  errorText: formState.name.displayError?.localize(l10n),
                ),
                PhoneField(
                  label: l10n.your_phone_number,
                  controller: _phoneController,
                  errorText: formState.phone.displayError?.localize(l10n),
                ),
                PasswordFieldApp(
                  label: l10n.choose_password,
                  controller: _passwordController,
                  errorText: formState.password.displayError?.localize(l10n),
                ),
                PasswordFieldApp(
                  label: l10n.confirm_the_password,
                  controller: _passwordVerifyController,
                  errorText: formState.passwordConfirmation.displayError
                      ?.localize(l10n),
                ),
                CityPicker(
                  label: l10n.choose_city,
                  controller: _cityController,
                  errorText: formState.city.displayError?.localize(l10n),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<RegisterUserBloc, RegisterUserState>(
            builder: (context, state) {
              if (state is RegisterUserLoading) {
                return ElevatedButtonApp(
                  onPressed: () {},
                  child: Loader(color: Theme.of(context).colorScheme.surface),
                );
              }
              return ElevatedButtonApp(
                text: l10n.register,
                onPressed: _register,
              );
            },
          ),
        ],
      ),
    );
  }
}
