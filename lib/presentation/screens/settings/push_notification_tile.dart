import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/settings/push_notification_cubit.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';

/// Самодостаточный блок настройки пуш-уведомлений: создаёт Cubit и сразу
/// дёргает init() (GET push-status). Можно вставлять в любой экран настроек.
class PushNotificationTile extends StatelessWidget {
  const PushNotificationTile({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => PushNotificationCubit()..init(),
        child: const _PushNotificationView(),
      );
}

class _PushNotificationView extends StatelessWidget {
  const _PushNotificationView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<PushNotificationCubit, PushNotificationState>(
      // Снэкбар показываем только при появлении НОВОЙ ошибки операции.
      listenWhen: (prev, curr) =>
          curr.error != null && curr.error != prev.error,
      listener: (context, state) {
        CustomSnackBar.error(Text(state.error!.messages.first)).view(context);
      },
      builder: (context, state) {
        final cubit = context.read<PushNotificationCubit>();

        return ListTile(
          title: Text(
            l10n.pushNotificationsTitle,
            style: const TextStyle(fontSize: 16),
          ),
          contentPadding: EdgeInsets.zero,
          subtitle: Text(_subtitle(l10n, state)),
          trailing: _Trailing(
              state: state, onRetry: cubit.init, onToggle: cubit.toggle),
        );
      },
    );
  }

  String _subtitle(AppLocalizations l10n, PushNotificationState state) {
    switch (state.status) {
      case PushNotificationStatus.loading:
        return l10n.pushNotificationsLoading;
      case PushNotificationStatus.error:
        return l10n.pushNotificationsLoadError;
      case PushNotificationStatus.loaded:
        return state.value
            ? l10n.pushNotificationsOn
            : l10n.pushNotificationsOff;
    }
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({
    required this.state,
    required this.onRetry,
    required this.onToggle,
  });

  final PushNotificationState state;
  final VoidCallback onRetry;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      // Нейтральное состояние: пока грузимся — НЕ показываем Switch в false,
      // а рисуем спиннер, чтобы не вводить пользователя в заблуждение.
      case PushNotificationStatus.loading:
        return const SizedBox(
          width: 40,
          height: 24,
          child: Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      case PushNotificationStatus.error:
        return TextButton(
          onPressed: onRetry,
          child: Text(AppLocalizations.of(context)!.retry),
        );
      case PushNotificationStatus.loaded:
        return Switch.adaptive(value: state.value, onChanged: onToggle);
    }
  }
}
