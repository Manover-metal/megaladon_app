import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/auth/password_recovery/password_recovery_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _phone;

  @override
  void initState() {
    _phone = TextEditingController(text: '+7');
    super.initState();
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _send() {
    final cubit = context.read<PasswordRecoveryCubit>();
    if (cubit.checkStep1(phone: _phone.value.text)) {
      cubit.sendCode(phone: _phone.value.text);
    }
  }

  void _listener(BuildContext context, PasswordRecoveryState state) {
    if (state.status == PasswordRecoveryStatus.success) {
      context.router.push(ResetPasswordRoute(phone: _phone.value.text));
    } else if (state.status == PasswordRecoveryStatus.error) {
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
          child: Container(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<PasswordRecoveryCubit, PasswordRecoveryState>(
              listener: _listener,
              builder: (context, state) => Column(
                children: [
                  const Spacer(),
                  TitleApp(AppLocalizations.of(context)!.password_recovery),
                  const SizedBox(height: 20),
                  PhoneField(
                    icon: const Icon(Icons.person),
                    label: AppLocalizations.of(context)!.your_phone_number,
                    controller: _phone,
                    errorText: state.phone.displayError
                        ?.localize(AppLocalizations.of(context)!),
                  ),
                  const SizedBox(height: 25),
                  if (state.status == PasswordRecoveryStatus.loading)
                    ElevatedButtonApp(
                      onPressed: () {},
                      child:
                          Loader(color: Theme.of(context).colorScheme.surface),
                    )
                  else
                    ElevatedButtonApp(
                      text: AppLocalizations.of(context)!.send_the_code,
                      onPressed: _send,
                    ),
                  OutlinedButtonApp(
                    text: AppLocalizations.of(context)!.cancel,
                    onPressed: () => context.router.pop(),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      );
}
