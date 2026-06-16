import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/profile/change_phone/change_phone_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ChangePhoneStartScreen extends StatefulWidget {
  const ChangePhoneStartScreen({super.key});

  @override
  State<ChangePhoneStartScreen> createState() => _ChangePhoneStartScreenState();
}

class _ChangePhoneStartScreenState extends State<ChangePhoneStartScreen> {
  late TextEditingController _newPhone;
  late TextEditingController _password;

  void _login() {
    if (_checkForm()) {
      context.read<ChangePhoneCubit>().changePhoneStart(
            phone: _newPhone.value.text,
            password: _password.value.text,
          );
    }
  }

  @override
  void initState() {
    _password = TextEditingController();
    _newPhone = TextEditingController(text: '+7');

    super.initState();
  }

  bool _checkForm() {
    var form = context.read<ChangePhoneCubit>();
    return form.checkStep1(
      phone: _newPhone.value.text,
      password: _password.value.text,
    );
  }

  @override
  void dispose() {
    _password.dispose();
    _newPhone.dispose();
    super.dispose();
  }

  dynamic _listenerForm(BuildContext context, ChangePhoneState state) {
    if (state.status == ChangePhoneStatus.success ||
        state.status == ChangePhoneStatus.initial2) {
      context.router.popAndPush(const ChangePhoneEndRoute());
    } else if (state.status == ChangePhoneStatus.error) {
      return CustomSnackBar.error(
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
                BlocListener<ChangePhoneCubit, ChangePhoneState>(
                    listener: _listenerForm)
              ],
              child: Column(
                children: [
                  const Spacer(),
                  TitleApp(AppLocalizations.of(context)!.change_phone_number),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<ChangePhoneCubit, ChangePhoneState>(
                    builder: (context, state) => Column(
                      children: [
                        PhoneField(
                          icon: const Icon(Icons.phone),
                          label: AppLocalizations.of(context)!.new_phone,
                          controller: _newPhone,
                          errorText: state.phone.displayError
                              ?.localize(AppLocalizations.of(context)!),
                        ),
                        TextFieldApp(
                          icon: const Icon(Icons.lock),
                          label: AppLocalizations.of(context)!.your_password,
                          controller: _password,
                          errorText: state.password.displayError
                              ?.localize(AppLocalizations.of(context)!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  BlocBuilder<ChangePhoneCubit, ChangePhoneState>(
                      builder: (context, state) {
                    if (state.status == ChangePhoneStatus.loading) {
                      return ElevatedButtonApp(
                          child: Loader(
                              color: Theme.of(context).colorScheme.surface),
                          onPressed: () {});
                    }
                    return ElevatedButtonApp(
                        text: AppLocalizations.of(context)!.submit_Code,
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
