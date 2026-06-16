import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/profile/change_password/change_password_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/password_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController _oldPassword;
  late TextEditingController _password;
  late TextEditingController _passwordConfirmation;

  void _login() {
    if (_checkForm()) {
      context.read<ChangePasswordCubit>().changePassword(
          oldPassword: _oldPassword.value.text,
          password: _password.value.text,
          passwordConfirmation: _passwordConfirmation.value.text);
    }
  }

  @override
  void initState() {
    _password = TextEditingController();
    _oldPassword = TextEditingController();
    _passwordConfirmation = TextEditingController();

    super.initState();
  }

  bool _checkForm() {
    var form = context.read<ChangePasswordCubit>();
    return form.check(
        oldPassword: _oldPassword.value.text,
        password: _password.value.text,
        passwordConfirmation: _passwordConfirmation.value.text);
  }

  @override
  void dispose() {
    _password.dispose();
    _oldPassword.dispose();
    _passwordConfirmation.dispose();
    super.dispose();
  }

  dynamic _listenerForm(BuildContext context, ChangePasswordState state) {
    if (state.status == ChangePasswordStatus.success) {
      CustomSnackBar.success(
        Text(AppLocalizations.of(context)!.password_changed_successfully),
      ).view(context);
      context.router.navigate(const InitialRouter(children: [ProfileRouter()]));
    } else if (state.status == ChangePasswordStatus.error) {
      CustomSnackBar.error(
        Text(
          state.error?.messages.isNotEmpty == true
              ? state.error!.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: MultiBlocListener(
              listeners: [
                BlocListener<ChangePasswordCubit, ChangePasswordState>(
                    listener: _listenerForm)
              ],
              child: Column(
                children: [
                  const Spacer(),
                  TitleApp(AppLocalizations.of(context)!.change_password),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                    builder: (context, state) => Column(
                      children: [
                        PasswordFieldApp(
                          icon: const Icon(Icons.lock),
                          label: AppLocalizations.of(context)!.your_password,
                          controller: _oldPassword,
                          errorText: state.oldPassword.displayError
                              ?.localize(AppLocalizations.of(context)!),
                        ),
                        PasswordFieldApp(
                          icon: const Icon(Icons.lock),
                          label: AppLocalizations.of(context)!.choose_password,
                          controller: _password,
                          errorText: state.password.displayError
                              ?.localize(AppLocalizations.of(context)!),
                        ),
                        PasswordFieldApp(
                          icon: const Icon(Icons.lock),
                          label: AppLocalizations.of(context)!
                              .confirm_the_password,
                          controller: _passwordConfirmation,
                          errorText: state.passwordConfirmation.displayError
                              ?.localize(AppLocalizations.of(context)!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                      builder: (context, state) {
                    if (state.status == ChangePasswordStatus.loading) {
                      return ElevatedButtonApp(
                          child: Loader(
                              color: Theme.of(context).colorScheme.surface),
                          onPressed: () {});
                    }
                    return ElevatedButtonApp(
                        text: AppLocalizations.of(context)!.edit,
                        onPressed: _login);
                  }),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      );
}
