import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/data/repositories/safety_repository.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/safety/blocks_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/hint_text.dart';

String _errorText(BuildContext context, Object error) {
  final model =
      error is DioException ? ErrorModel.parseDio(error) : ErrorModel.nothing;
  return model.messages.isNotEmpty
      ? model.messages.first
      : AppLocalizations.of(context)!.unknown_error;
}

/// Меню «Пожаловаться / Заблокировать» на чужого пользователя. Открывается из
/// шапки профиля, заказа, объявления и чата.
Future<void> showUserActionsSheet(
  BuildContext context, {
  required UserModel user,
  ReportTarget target = ReportTarget.user,
  int? targetId,
}) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<BlocksCubit>(),
        child: _UserActionsSheet(
          user: user,
          target: target,
          targetId: targetId,
          // Снекбары и диалоги показываем на экране под шторкой — она к тому
          // моменту уже закрыта.
          host: context,
        ),
      ),
    );

class _UserActionsSheet extends StatelessWidget {
  const _UserActionsSheet({
    required this.user,
    required this.target,
    required this.targetId,
    required this.host,
  });

  final UserModel user;
  final ReportTarget target;
  final int? targetId;
  final BuildContext host;

  Future<void> _report(BuildContext context) async {
    Navigator.of(context).pop();
    await showReportSheet(host, user: user, target: target, targetId: targetId);
  }

  Future<void> _toggleBlock(BuildContext context, bool blocked) async {
    Navigator.of(context).pop();
    final l10n = AppLocalizations.of(host)!;
    final cubit = host.read<BlocksCubit>();

    if (!blocked) {
      final ok = await showDialog<bool>(
        context: host,
        builder: (dialog) => AlertDialog(
          title: Text(l10n.safetyBlockTitle),
          content: Text(l10n.safetyBlockBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialog).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialog).pop(true),
              child: Text(l10n.safetyBlock),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }

    try {
      if (blocked) {
        await cubit.unblock(user.id);
      } else {
        await cubit.block(user);
      }
      if (!host.mounted) return;
      CustomSnackBar.success(
        Text(blocked ? l10n.safetyUnblockDone : l10n.safetyBlockDone),
      ).view(host);
    } on Object catch (error) {
      if (!host.mounted) return;
      CustomSnackBar.error(Text(_errorText(host, error))).view(host);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final blocked = context.watch<BlocksCubit>().state.isBlocked(user.id);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButtonApp(
            text: l10n.safetyReport,
            onPressed: () => _report(context),
          ),
          HintText(l10n.safetyReportHint),
          const SizedBox(height: 5),
          ElevatedButtonApp(
            text: blocked ? l10n.safetyUnblock : l10n.safetyBlock,
            onPressed: () => _toggleBlock(context, blocked),
          ),
          if (!blocked) HintText(l10n.safetyBlockHint),
        ],
      ),
    );
  }
}

/// Шторка жалобы: причина чипами и необязательный комментарий.
Future<void> showReportSheet(
  BuildContext context, {
  required UserModel user,
  ReportTarget target = ReportTarget.user,
  int? targetId,
}) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => _ReportSheet(
        user: user,
        target: target,
        targetId: targetId,
        host: context,
      ),
    );

class _ReportSheet extends StatefulWidget {
  const _ReportSheet({
    required this.user,
    required this.target,
    required this.targetId,
    required this.host,
  });

  final UserModel user;
  final ReportTarget target;
  final int? targetId;
  final BuildContext host;

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  final _comment = TextEditingController();
  ReportReason? _reason;
  String? _reasonError;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  String _reasonLabel(ReportReason reason, AppLocalizations l10n) {
    switch (reason) {
      case ReportReason.spam:
        return l10n.safetyReasonSpam;
      case ReportReason.abuse:
        return l10n.safetyReasonAbuse;
      case ReportReason.inappropriate:
        return l10n.safetyReasonInappropriate;
      case ReportReason.fake:
        return l10n.safetyReasonFake;
      case ReportReason.other:
        return l10n.safetyReasonOther;
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final reason = _reason;
    if (reason == null) {
      setState(() => _reasonError = l10n.safetyReasonRequired);
      return;
    }

    try {
      final message = await SafetyRepository().report(
        userId: widget.user.id,
        reason: reason,
        target: widget.target,
        targetId: widget.targetId,
        comment: _comment.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      if (!widget.host.mounted) return;
      CustomSnackBar.success(Text(message ?? l10n.safetyReportSent))
          .view(widget.host);
    } on Object catch (error) {
      if (!mounted) return;
      CustomSnackBar.error(Text(_errorText(context, error))).view(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      // Поднимаем шторку над клавиатурой, когда пишут комментарий.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        color: theme.colorScheme.surface,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.safetyReportTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final reason in ReportReason.values)
                  ChoiceChip(
                    label: Text(_reasonLabel(reason, l10n)),
                    selected: _reason == reason,
                    onSelected: (_) => setState(() {
                      _reason = reason;
                      _reasonError = null;
                    }),
                  ),
              ],
            ),
            if (_reasonError != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _reasonError!,
                  style:
                      TextStyle(color: theme.colorScheme.error, fontSize: 12),
                ),
              ),
            const SizedBox(height: 8),
            DescriptionFieldApp(
              controller: _comment,
              label: l10n.safetyCommentHint,
            ),
            HintText(l10n.safetyReportHint),
            const SizedBox(height: 10),
            ElevatedButtonApp(
              text: l10n.safetyReportSubmit,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
