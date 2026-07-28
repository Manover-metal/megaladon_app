import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/auth/password_recovery/password_recovery_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/password_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({required this.phone, super.key});
  final String phone;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController _code;
  late TextEditingController _password;
  late TextEditingController _passwordConfirmation;

  @override
  void initState() {
    _code = TextEditingController();
    _password = TextEditingController();
    _passwordConfirmation = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    _passwordConfirmation.dispose();
    super.dispose();
  }

  void _submit() {
    final cubit = context.read<PasswordRecoveryCubit>();
    if (cubit.checkStep2(
      code: _code.value.text,
      password: _password.value.text,
      passwordConfirmation: _passwordConfirmation.value.text,
    )) {
      cubit.resetPassword(
        phone: widget.phone,
        code: _code.value.text,
        password: _password.value.text,
        passwordConfirmation: _passwordConfirmation.value.text,
      );
    }
  }

  void _listener(BuildContext context, PasswordRecoveryState state) {
    if (state.status == PasswordRecoveryStatus.success2) {
      CustomSnackBar.success(
        Text(AppLocalizations.of(context)!.password_changed_successfully),
      ).view(context);
      // Возвращаемся к уже существующему экрану логина в стеке
      // (под ним остаётся InitialRouter с табами), а не пересоздаём стек —
      // иначе каркас приложения теряется и с логина некуда выйти.
      context.router.popUntil((route) => route.settings.name == LoginRoute.name);
    } else if (state.status == PasswordRecoveryStatus.error2) {
      CustomSnackBar.error(
        Text(state.error?.messages.isNotEmpty == true
            ? state.error!.messages.first
            : AppLocalizations.of(context)!.unknown_error),
      ).view(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: BlocConsumer<PasswordRecoveryCubit, PasswordRecoveryState>(
                listener: _listener,
                builder: (context, state) => Column(
                  children: [
                    TitleApp(AppLocalizations.of(context)!.password_recovery),
                    const SizedBox(height: 20),
                    TextFieldApp(
                      controller: _code,
                      label: AppLocalizations.of(context)!
                          .enter_6digit_code_from_SMS,
                      errorText: state.code.displayError
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
                      label: AppLocalizations.of(context)!.confirm_the_password,
                      controller: _passwordConfirmation,
                      errorText: state.passwordConfirmation.displayError
                          ?.localize(AppLocalizations.of(context)!),
                    ),
                    const SizedBox(height: 25),
                    if (state.status == PasswordRecoveryStatus.loading2)
                      ElevatedButtonApp(
                        onPressed: () {},
                        child: Loader(
                            color: Theme.of(context).colorScheme.surface),
                      )
                    else
                      ElevatedButtonApp(
                        text: AppLocalizations.of(context)!.reset_password,
                        onPressed: _submit,
                      ),
                    OutlinedButtonApp(
                      text: AppLocalizations.of(context)!.cancel,
                      onPressed: () => context.router.pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
