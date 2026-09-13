import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/auth/auth_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/auth/auth_scaffold.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/password_field.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
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
    // push, а не popAndPush: с экрана регистрации нужно уметь вернуться сюда.
    context.router.push(const RegisterUserRoute());
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

  // Ошибки формы поля показывают сами, под собой. Снекбар остаётся за
  // ответом сервера — раньше одна и та же фраза приходила дважды.
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: _listenerAuth,
      child: AuthScaffold(
        footer: const UserAgreementText(),
        children: [
          AuthHeading(title: l10n.authorization, subtitle: l10n.login_subtitle),
          const SizedBox(height: 20),
          BlocBuilder<AuthFormCubit, AuthFormState>(
            builder: (context, formState) => AuthFieldGroup(
              children: [
                PhoneField(
                  label: l10n.your_phone_number,
                  controller: _phone,
                  errorText: formState.phone.displayError?.localize(l10n),
                ),
                PasswordFieldApp(
                  label: l10n.your_password,
                  controller: _password,
                  errorText: formState.password.displayError?.localize(l10n),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => context.router.push(const ForgotPasswordRoute()),
              child: Text(
                l10n.forgot_your_password,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return ElevatedButtonApp(
                  onPressed: () {},
                  child: Loader(color: Theme.of(context).colorScheme.surface),
                );
              }
              return ElevatedButtonApp(text: l10n.sign_in, onPressed: _login);
            },
          ),
          const SizedBox(height: 8),
          OutlinedButtonApp(text: l10n.create_account, onPressed: _register),
        ],
      ),
    );
  }
}
