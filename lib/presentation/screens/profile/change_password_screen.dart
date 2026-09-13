import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/profile/change_password/change_password_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/auth/auth_scaffold.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/password_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';

/// Смена пароля: текущий и новый дважды. Собран так же, как экраны
/// регистрации: заголовок с пояснением, поля одной карточкой. Раньше у
/// экрана не было шапки и кнопки «назад».
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController _oldPassword;
  late TextEditingController _password;
  late TextEditingController _passwordConfirmation;

  void _save() {
    final cubit = context.read<ChangePasswordCubit>();
    if (!cubit.check(
        oldPassword: _oldPassword.value.text,
        password: _password.value.text,
        passwordConfirmation: _passwordConfirmation.value.text)) {
      return;
    }

    cubit.changePassword(
        oldPassword: _oldPassword.value.text,
        password: _password.value.text,
        passwordConfirmation: _passwordConfirmation.value.text);
  }

  // Ошибки полей рисуются под полями, снекбар — только за ответом сервера.
  void _listen(BuildContext context, ChangePasswordState state) {
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
  void initState() {
    _password = TextEditingController();
    _oldPassword = TextEditingController();
    _passwordConfirmation = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _password.dispose();
    _oldPassword.dispose();
    _passwordConfirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: _listen,
      child: AuthScaffold(
        title: l10n.change_password,
        children: [
          AuthHeading(
            title: l10n.change_password,
            subtitle: l10n.change_password_subtitle,
          ),
          const SizedBox(height: 20),
          BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
            builder: (context, state) => AuthFieldGroup(
              children: [
                PasswordFieldApp(
                  label: l10n.your_password,
                  controller: _oldPassword,
                  errorText: state.oldPassword.displayError?.localize(l10n),
                ),
                PasswordFieldApp(
                  label: l10n.choose_password,
                  controller: _password,
                  errorText: state.password.displayError?.localize(l10n),
                ),
                PasswordFieldApp(
                  label: l10n.confirm_the_password,
                  controller: _passwordConfirmation,
                  errorText:
                      state.passwordConfirmation.displayError?.localize(l10n),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
            builder: (context, state) {
              if (state.status == ChangePasswordStatus.loading) {
                return ElevatedButtonApp(
                  onPressed: () {},
                  child: Loader(color: Theme.of(context).colorScheme.surface),
                );
              }
              return ElevatedButtonApp(
                text: l10n.save_changes,
                onPressed: _save,
              );
            },
          ),
        ],
      ),
    );
  }
}
