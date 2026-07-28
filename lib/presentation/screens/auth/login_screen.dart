import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/auth/auth_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/password_field.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/text/user_agreement_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _password;
  late TextEditingController _phone;

  void _register() {
    context.router.popAndPush(const RegisterUserRoute());
  }

  void _login() {
    if (_checkForm()) {
      context
          .read<AuthBloc>()
          .add(AuthLoginEvent(_phone.value.text, _password.value.text));
      return;
    }
  }

  @override
  void initState() {
    _password = TextEditingController();
    _phone = TextEditingController(text: '+7');
    super.initState();
  }

  bool _checkForm() {
    var form = context.read<AuthFormCubit>();
    return form.checkLogin(
      phone: _phone.value.text,
      password: _password.value.text,
    );
  }

  @override
  void dispose() {
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _listenerAuth(BuildContext context, AuthState state) {
    if (state is AuthLoginState) {
      context.router.replaceAll([
        const InitialRouter(children: [ProfileRouter()])
      ]);
    } else if (state is AuthErrorState) {
      CustomSnackBar.error(
        Text(
          state.error.messages.isNotEmpty
              ? state.error.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    } else if (state is AuthTransitionVerify) {
      context.router.replace(VerifyRoute(phone: _phone.value.text));
    }
  }

  void _listenerForm(BuildContext context, AuthFormState state) {
    if (!state.status) {
      for (final element in state.props) {
        if (element is FormzInput && element.isNotValid) {
          final err = element.error;
          CustomSnackBar.error(
            Text(err is LocalizableError
                ? err.localize(AppLocalizations.of(context)!)
                : AppLocalizations.of(context)!.unknown_error),
          ).view(context);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(listener: _listenerAuth),
              BlocListener<AuthFormCubit, AuthFormState>(
                  listener: _listenerForm)
            ],
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  TitleApp(AppLocalizations.of(context)!.authorization),
                  // Spacer(),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<AuthFormCubit, AuthFormState>(
                    builder: (context, formState) => Column(
                      children: [
                        PhoneField(
                          icon: const Icon(Icons.person),
                          label:
                              AppLocalizations.of(context)!.your_phone_number,
                          controller: _phone,
                          errorText: formState.phone.displayError
                              ?.localize(AppLocalizations.of(context)!),
                        ),
                        PasswordFieldApp(
                          icon: const Icon(Icons.lock),
                          label: AppLocalizations.of(context)!.your_password,
                          controller: _password,
                          errorText: formState.password.displayError
                              ?.localize(AppLocalizations.of(context)!),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () =>
                          context.router.push(const ForgotPasswordRoute()),
                      child: Text(
                          AppLocalizations.of(context)!.forgot_your_password,
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    if (state is AuthLoadingState) {
                      return ElevatedButtonApp(
                          child: Loader(
                              color: Theme.of(context).colorScheme.surface),
                          onPressed: () {});
                    }
                    return ElevatedButtonApp(
                        text: AppLocalizations.of(context)!.sign_in,
                        onPressed: _login);
                  }),
                  OutlinedButtonApp(
                      text: AppLocalizations.of(context)!.registration,
                      onPressed: _register),
                  const SizedBox(height: 15),
                  const UserAgreementText(),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      );
}
