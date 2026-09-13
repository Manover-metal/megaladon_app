import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/profile/change_phone/change_phone_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/auth/auth_scaffold.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/password_field.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';

/// Смена номера, шаг 1: новый номер и текущий пароль. Бэкенд проверяет
/// пароль и шлёт СМС с кодом на новый номер. Собран так же, как экраны
/// регистрации. Раньше пароль вводился открытым текстом, а у экрана не было
/// шапки и кнопки «назад».
class ChangePhoneStartScreen extends StatefulWidget {
  const ChangePhoneStartScreen({super.key});

  @override
  State<ChangePhoneStartScreen> createState() => _ChangePhoneStartScreenState();
}

class _ChangePhoneStartScreenState extends State<ChangePhoneStartScreen> {
  late TextEditingController _newPhone;
  late TextEditingController _password;

  void _sendCode() {
    final cubit = context.read<ChangePhoneCubit>();
    if (!cubit.checkStep1(
      phone: _newPhone.value.text,
      password: _password.value.text,
    )) {
      return;
    }

    cubit.changePhoneStart(
      phone: _newPhone.value.text,
      password: _password.value.text,
    );
  }

  // Ошибки полей рисуются под полями, снекбар — только за ответом сервера.
  void _listen(BuildContext context, ChangePhoneState state) {
    if (state.status == ChangePhoneStatus.success) {
      context.router.popAndPush(const ChangePhoneEndRoute());
    } else if (state.status == ChangePhoneStatus.error) {
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
    _newPhone = TextEditingController(text: '+7');
    super.initState();
  }

  @override
  void dispose() {
    _password.dispose();
    _newPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ChangePhoneCubit, ChangePhoneState>(
      listener: _listen,
      child: AuthScaffold(
        title: l10n.change_phone_number,
        children: [
          AuthHeading(
            title: l10n.change_phone_number,
            subtitle: l10n.change_phone_subtitle,
          ),
          const SizedBox(height: 20),
          BlocBuilder<ChangePhoneCubit, ChangePhoneState>(
            builder: (context, state) => AuthFieldGroup(
              children: [
                PhoneField(
                  label: l10n.new_phone,
                  controller: _newPhone,
                  errorText: state.phone.displayError?.localize(l10n),
                ),
                PasswordFieldApp(
                  label: l10n.your_password,
                  controller: _password,
                  errorText: state.password.displayError?.localize(l10n),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<ChangePhoneCubit, ChangePhoneState>(
            builder: (context, state) {
              if (state.status == ChangePhoneStatus.loading) {
                return ElevatedButtonApp(
                  onPressed: () {},
                  child: Loader(color: Theme.of(context).colorScheme.surface),
                );
              }
              return ElevatedButtonApp(
                text: l10n.submit_Code,
                onPressed: _sendCode,
              );
            },
          ),
        ],
      ),
    );
  }
}
