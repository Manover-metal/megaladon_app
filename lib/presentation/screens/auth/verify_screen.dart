import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/repositories/auth/verify_repository.dart';
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
  static const _cooldownSeconds = 60;

  late PinInputController _pinController;
  final VerifyRepository _verifyRepository = VerifyRepository();
  Timer? _timer;
  int _secondsLeft = _cooldownSeconds;

  bool _checkForm() =>
      context.read<VerifyFormCubit>().checkForm(_pinController.text);

  void _verify() {
    if (_checkForm()) {
      context
          .read<AuthBloc>()
          .add(AuthVerifyEvent(widget.phone, _pinController.text));
    }
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _cooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _resend() async {
    if (_secondsLeft > 0) return;
    try {
      await _verifyRepository.resendCode(phone: widget.phone);
      _startCooldown();
      if (mounted) {
        CustomSnackBar.success(
          Text(AppLocalizations.of(context)!.code_sent_again),
        ).view(context);
      }
    } catch (_) {
      if (mounted) {
        CustomSnackBar.error(
          Text(AppLocalizations.of(context)!.unknown_error),
        ).view(context);
      }
    }
  }

  @override
  void initState() {
    _listenerVerify(false);
    _pinController = PinInputController();
    _startCooldown();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _listenerForm(BuildContext context, VerifyFormState state) {
    if (state.pincode.isNotValid) {
      CustomSnackBar.error(
        Text(
          state.pincode.error!.localize(AppLocalizations.of(context)!),
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
                    text: _secondsLeft > 0
                        ? '${AppLocalizations.of(context)!.send_code_again} ($_secondsLeft)'
                        : AppLocalizations.of(context)!.send_code_again,
                    onPressed: _secondsLeft > 0 ? null : _resend,
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      );
}
