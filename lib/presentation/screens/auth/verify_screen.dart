import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/repositories/auth/verify_repository.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/verify/verify_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/auth/auth_scaffold.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
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
    // Код уже проверяется: второе нажатие в тот же кадр, до смены кнопки на
    // крутилку, отправило бы второй запрос.
    if (context.read<AuthBloc>().state is AuthLoadingState) return;
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

  /// Остаток ожидания в виде «0:57».
  String get _cooldownLabel =>
      '${_secondsLeft ~/ 60}:${(_secondsLeft % 60).toString().padLeft(2, '0')}';

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

  // У поля кода нет места под ошибку внутри самого поля, поэтому здесь
  // снекбар остаётся — в отличие от экранов с обычными полями.
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyFormCubit, VerifyFormState>(
          listener: _listenerForm,
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: _listenerVerify(true),
        )
      ],
      child: AuthScaffold(
        title: l10n.registration,
        children: [
          AuthHeading(
            title: l10n.sms_code_title,
            subtitle: l10n.code_sent_to(widget.phone),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              // Номер вводится на предыдущем экране: возвращаемся туда,
              // а не заставляем набирать форму заново.
              onTap: () => context.router.pop(),
              child: Text(
                l10n.change_number,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 24),
          MaterialPinField(
            pinController: _pinController,
            length: 6,
            theme: MaterialPinTheme(
              borderRadius: BorderRadius.circular(10),
              borderWidth: 1,
              fillColor: scheme.tertiary,
              borderColor: scheme.onTertiary,
              filledBorderColor: scheme.primary,
              focusedBorderColor: scheme.primary,
            ),
            onChanged: (value) {},
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              // Крутилка на время запроса. Раньше здесь проверялся
              // AuthLoginState — то есть успех: пока код уходил на сервер,
              // кнопка оставалась активной и нажималась повторно.
              if (state is AuthLoadingState) {
                return ElevatedButtonApp(
                  onPressed: () {},
                  child: Loader(color: scheme.surface),
                );
              }
              return ElevatedButtonApp(
                text: l10n.confirm,
                onPressed: _verify,
              );
            },
          ),
          const SizedBox(height: 8),
          OutlinedButtonApp(
            text: _secondsLeft > 0
                ? l10n.resend_code_in(_cooldownLabel)
                : l10n.send_code_again,
            onPressed: _secondsLeft > 0 ? null : _resend,
          ),
        ],
      ),
    );
  }
}
