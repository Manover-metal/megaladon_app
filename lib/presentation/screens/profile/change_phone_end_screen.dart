import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/profile/change_phone/change_phone_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/auth/auth_scaffold.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Смена номера, шаг 2: код из СМС. Код приходит на новый номер, и бэкенд
/// ищет его по этому же номеру (`/user/change-phone/end`). Номер берём из
/// шага 1 — ChangePhoneCubit живёт на всё приложение. Раньше номер
/// приходилось набирать заново, да ещё под подписью «Старый телефон».
class ChangePhoneEndScreen extends StatefulWidget {
  const ChangePhoneEndScreen({super.key});

  @override
  State<ChangePhoneEndScreen> createState() => _ChangePhoneEndScreenState();
}

class _ChangePhoneEndScreenState extends State<ChangePhoneEndScreen> {
  late final String _phone;
  late PinInputController _pinController;

  void _confirm() {
    final cubit = context.read<ChangePhoneCubit>();
    if (!cubit.checkStep2(phone: _phone, code: _pinController.text)) return;

    cubit.changePhoneEnd(phone: _phone, code: _pinController.text);
  }

  void _listen(BuildContext context, ChangePhoneState state) {
    if (state.status == ChangePhoneStatus.success2) {
      CustomSnackBar.success(
        Text(AppLocalizations.of(context)!.phone_number_changed_successfully),
      ).view(context);
      context.router.navigate(const InitialRouter(children: [ProfileRouter()]));
    } else if (state.status == ChangePhoneStatus.error2) {
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
    _phone = context.read<ChangePhoneCubit>().state.phone.value;
    _pinController = PinInputController();
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return BlocListener<ChangePhoneCubit, ChangePhoneState>(
      listener: _listen,
      child: AuthScaffold(
        title: l10n.change_phone_number,
        children: [
          AuthHeading(
            title: l10n.sms_code_title,
            subtitle: l10n.code_sent_to(_phone),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              // Шаг 1 закрыт через popAndPush — возвращаемся заменой, а не pop.
              onTap: () => context.router.replace(const ChangePhoneStartRoute()),
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
          BlocBuilder<ChangePhoneCubit, ChangePhoneState>(
            buildWhen: (a, b) => a.code != b.code,
            builder: (context, state) {
              final error = state.code.displayError;
              if (error == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  error.localize(l10n),
                  style: TextStyle(color: scheme.error, fontSize: 12),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          BlocBuilder<ChangePhoneCubit, ChangePhoneState>(
            builder: (context, state) {
              if (state.status == ChangePhoneStatus.loading2) {
                return ElevatedButtonApp(
                  onPressed: () {},
                  child: Loader(color: scheme.surface),
                );
              }
              return ElevatedButtonApp(
                text: l10n.confirm,
                onPressed: _confirm,
              );
            },
          ),
        ],
      ),
    );
  }
}
