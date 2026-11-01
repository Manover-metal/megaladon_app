import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/support_ticket_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/support/support_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/media_multi_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/hint_text.dart';

/// Форма обращения в поддержку: текст и до трёх скриншотов.
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  static const int _minLength = 10;

  final _message = TextEditingController();
  final _images = ImageMultiPickerController();
  String? _error;

  @override
  void dispose() {
    _message.dispose();
    _images.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _message.text.trim();
    if (text.length < _minLength) {
      setState(() => _error = l10n.supportMinLength(_minLength));
      return;
    }
    setState(() => _error = null);

    try {
      await context.read<SupportCubit>().repository.create(text, _images.value);
      if (!mounted) return;
      await context.router.replace(const SupportSentRoute());
    } on Object catch (error) {
      if (!mounted) return;
      final model = error is DioException
          ? ErrorModel.parseDio(error)
          : ErrorModel.nothing;
      CustomSnackBar.error(Text(model.messages.isNotEmpty
              ? model.messages.first
              : l10n.unknown_error))
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
        title: l10n.supportTitle,
        trailing: const Icon(Icons.history, size: 26),
        onTrailing: () => context.router.push(const SupportTicketsRoute()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HintText(l10n.supportIntro),
            const SizedBox(height: 12),
            DescriptionFieldApp(
              controller: _message,
              label: l10n.supportDescriptionHint,
              errorText: _error,
            ),
            const SizedBox(height: 12),
            SectionTitle(l10n.supportAttach),
            const SizedBox(height: 8),
            ImageMultiPicker(controller: _images, maxCount: 3),
            const SizedBox(height: 20),
            ElevatedButtonApp(text: l10n.supportSubmit, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}

/// «Спасибо, получили» после отправки.
class SupportSentScreen extends StatelessWidget {
  const SupportSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const HeaderAppBar(isBack: true, compactTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.check_circle_outline, size: 56, color: scheme.primary),
            const SizedBox(height: 16),
            Text(
              l10n.supportSentTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.supportSentBody,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: scheme.secondary),
            ),
            const SizedBox(height: 28),
            ElevatedButtonApp(
              text: l10n.supportSentDone,
              onPressed: () => context.router.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Мои обращения и ответы поддержки.
class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SupportCubit>().fetch();
  }

  String _statusName(SupportTicketStatus status, AppLocalizations l10n) {
    switch (status) {
      case SupportTicketStatus.open:
        return l10n.supportStatusOpen;
      case SupportTicketStatus.answered:
        return l10n.supportStatusAnswered;
      case SupportTicketStatus.closed:
        return l10n.supportStatusClosed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HeaderAppBar(
          isBack: true, compactTitle: true, title: l10n.supportTicketsTitle),
      body: RefreshIndicator(
        onRefresh: () => context.read<SupportCubit>().fetch(),
        child: BlocBuilder<SupportCubit, SupportState>(
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
      BuildContext context, SupportState state, AppLocalizations l10n) {
    if (state.status == SupportStatus.loading ||
        state.status == SupportStatus.initial) {
      return const SliverFillRemaining(
          hasScrollBody: false, child: Center(child: Loader()));
    }
    if (state.status == SupportStatus.error && state.error != null) {
      return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: ErrorMessage(error: state.error!)));
    }
    if (state.tickets.isEmpty) {
      return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: HintText(l10n.supportTicketsEmpty)));
    }

    return SliverList.separated(
      itemCount: state.tickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _Ticket(
        ticket: state.tickets[i],
        statusName: _statusName(state.tickets[i].status, l10n),
      ),
    );
  }
}

class _Ticket extends StatelessWidget {
  const _Ticket({required this.ticket, required this.statusName});

  final SupportTicketModel ticket;
  final String statusName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final answered = ticket.adminReply?.isNotEmpty == true;

    return CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(ticket.createdAt),
                  style: TextStyle(fontSize: 11.5, color: scheme.secondary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: answered
                      ? scheme.primary.withValues(alpha: 0.14)
                      : scheme.onTertiary,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  statusName,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: answered ? scheme.primary : scheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(ticket.message),
          if (answered) ...[
            const SizedBox(height: 10),
            SectionTitle(l10n.supportReplyLabel),
            const SizedBox(height: 4),
            Text(ticket.adminReply!),
          ],
        ],
      ),
    );
  }
}
