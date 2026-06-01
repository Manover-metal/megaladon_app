import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/verify/verify_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({required this.phone, super.key});
  final String phone;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late PinInputController _pinController;

  bool _checkForm() =>
      context.read<VerifyFormCubit>().checkForm(_pinController.text);

  void _verify() {
    if (_checkForm()) {
      context
          .read<AuthBloc>()
          .add(AuthVerifyEvent(widget.phone, _pinController.text));
    }
  }

  @override
  void initState() {
    _listenerVerify(false);
    _pinController = PinInputController();
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _listenerForm(BuildContext context, VerifyFormState state) {
    if (state.pincode.isNotValid) {
      CustomSnackBar.error(
        Text(
          state.pincode.error.toString(),
        ),
      ).view(context);
    }
  }

  Null Function(BuildContext context, AuthState state) _listenerVerify(
          bool isListener) =>
      (context, state) {
        if (state is AuthLoginState) {
          context.router.replaceAll([
            const InitialRouter(children: [ProfileRouter()])
          ]);
        } else if (state is AuthErrorState && isListener) {
          CustomSnackBar.error(
            Text(
              state.error.messages.isNotEmpty
                  ? state.error.messages.first
                  : AppLocalizations.of(context)!.unknown_error,
            ),
          ).view(context);
        }
      };

  @override
  Widget build(BuildContext context) => Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<VerifyFormCubit, VerifyFormState>(
              listener: _listenerForm,
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: _listenerVerify(true),
            )
          ],
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Spacer(),
                  TitleApp(AppLocalizations.of(context)!.registration),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialPinField(
                    pinController: _pinController,
                    length: 6,
                    theme: MaterialPinTheme(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onChanged: (value) {},
                  ),
                  Text(
                      AppLocalizations.of(context)!.enter_6digit_code_from_SMS),
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    if (state is AuthLoginState) {
                      return ElevatedButtonApp(
                          onPressed: _verify,
                          child: Loader(
                              color: Theme.of(context).colorScheme.surface));
                    }
                    return ElevatedButtonApp(
                      text: AppLocalizations.of(context)!.confirm,
                      onPressed: _verify,
                    );
                  }),
                  OutlinedButtonApp(
                      text: AppLocalizations.of(context)!.send_code_again),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      );
}
