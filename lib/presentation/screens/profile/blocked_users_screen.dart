import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/safety/blocks_cubit.dart';
import 'package:megaladon/presentation/widgets/avatar/avatar.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/hint_text.dart';

/// Кого я заблокировал. Разблокировка — кнопкой в строке.
class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  Future<void> _unblock(BuildContext context, UserModel user) async {
    try {
      await context.read<BlocksCubit>().unblock(user.id);
      if (!context.mounted) return;
      CustomSnackBar.success(
              Text(AppLocalizations.of(context)!.safetyUnblockDone))
          .view(context);
    } on Object catch (_) {
      if (!context.mounted) return;
      CustomSnackBar.error(Text(AppLocalizations.of(context)!.unknown_error))
          .view(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HeaderAppBar(
        isBack: true,
        compactTitle: true,
        title: l10n.safetyBlockedTitle,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<BlocksCubit>().fetch(),
        child: BlocBuilder<BlocksCubit, BlocksState>(
          builder: (context, state) => CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                sliver: _sliver(context, state, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sliver(
      BuildContext context, BlocksState state, AppLocalizations l10n) {
    if (state.status == BlocksStatus.loading && state.users.isEmpty) {
      return const SliverFillRemaining(
          hasScrollBody: false, child: Center(child: Loader()));
    }
    if (state.status == BlocksStatus.error && state.error != null) {
      return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: ErrorMessage(error: state.error!)));
    }
    if (state.users.isEmpty) {
      return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: HintText(l10n.safetyBlockedEmpty)));
    }

    return SliverToBoxAdapter(
      child: CardBox(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (var i = 0; i < state.users.length; i++) ...[
              if (i > 0)
                Container(
                    height: 1, color: Theme.of(context).colorScheme.onTertiary),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                child: _row(context, state.users[i], l10n),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, UserModel user, AppLocalizations l10n) =>
      Row(
        children: [
          Avatar(name: user.name, photoUrl: user.photo, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontStyle: user.isDeleted ? FontStyle.italic : null,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _unblock(context, user),
            child: Text(l10n.safetyUnblock),
          ),
        ],
      );
}
