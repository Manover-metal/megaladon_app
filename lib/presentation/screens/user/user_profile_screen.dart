import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/logic/screens/user/user_profile_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/card/ad_card.dart';
import 'package:megaladon/presentation/widgets/card/order_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/review/user_reviews_section.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';
import 'package:megaladon/presentation/widgets/text/hint_text.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({required this.userId, super.key});

  final int userId;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => UserProfileCubit(userId)..loadProfile(),
        child: _UserProfileView(userId: userId),
      );
}

class _UserProfileView extends StatefulWidget {
  const _UserProfileView({required this.userId});

  final int userId;

  @override
  State<_UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<_UserProfileView> {
  static const double _gap = 18;

  /// Сколько позиций показываем в разделе до нажатия «Показать все».
  static const int _preview = 3;

  final Set<UserProfileTab> _expanded = {};

  @override
  void initState() {
    super.initState();
    // Вкладок больше нет — разделы идут одной лентой, поэтому грузим все три
    // сразу. loadTab сам защищён от повторных запросов.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<UserProfileCubit>();
      UserProfileTab.values.forEach(cubit.loadTab);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HeaderAppBar(
        isBack: true,
        compactTitle: true,
        title: l10n.userProfileTitle,
      ),
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) => CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              sliver: _sliver(context, state),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) => state.user == null
            ? const SizedBox.shrink()
            : _ContactBar(user: state.user!),
      ),
    );
  }

  Widget _sliver(BuildContext context, UserProfileState state) {
    final l10n = AppLocalizations.of(context)!;

    if (state.profileStatus == LoadStatus.loading ||
        state.profileStatus == LoadStatus.initial) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Loader()),
      );
    }
    if (state.profileStatus == LoadStatus.error || state.user == null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: _Message(
            text: l10n.userProfileNotFound,
            actionText: l10n.userProfileRetry,
            onAction: () => context.read<UserProfileCubit>().loadProfile(),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(child: _content(context, state));
  }

  Widget _content(BuildContext context, UserProfileState state) {
    final l10n = AppLocalizations.of(context)!;
    final user = state.user!;

    final sections = <Widget?>[
      _sectionFor(
        context,
        tab: UserProfileTab.adverts,
        title: l10n.userProfileTabAdverts,
        items: state.adverts.map((a) => AdCard(advert: a)).toList(),
        total: state.adverts.length,
      ),
      _sectionFor(
        context,
        tab: UserProfileTab.services,
        title: l10n.userProfileTabServices,
        items: state.services.map((a) => AdCard(advert: a)).toList(),
        total: state.services.length,
      ),
      _sectionFor(
        context,
        tab: UserProfileTab.orders,
        title: l10n.userProfileTabOrders,
        items: state.orders.map((o) => OrderCard(order: o)).toList(),
        total: state.orders.length,
      ),
    ].whereType<Widget>().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(user: user),
        // Пока все три раздела грузятся, показываем один индикатор, а не три.
        if (sections.isEmpty && _anyLoading(state)) ...[
          const SizedBox(height: 40),
          const Center(child: Loader()),
        ],
        for (final section in sections) ...[
          const SizedBox(height: _gap),
          section,
        ],
        const SizedBox(height: _gap),
        UserReviewsSection(userId: widget.userId),
      ],
    );
  }

  bool _anyLoading(UserProfileState state) => UserProfileTab.values.any((tab) =>
      state.statusOf(tab) == LoadStatus.loading ||
      state.statusOf(tab) == LoadStatus.initial);

  /// Раздел ленты. Пустой список не рисуется вовсе — в этом и смысл: у
  /// заказчика без объявлений раньше было две пустые вкладки из трёх.
  Widget? _sectionFor(
    BuildContext context, {
    required UserProfileTab tab,
    required String title,
    required List<Widget> items,
    required int total,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final status = context.read<UserProfileCubit>().state.statusOf(tab);

    if (status == LoadStatus.error) {
      return ContentSection(
        title: title,
        child: _Message(
          text: l10n.userProfileLoadError,
          actionText: l10n.userProfileRetry,
          onAction: () => context.read<UserProfileCubit>().retryTab(tab),
        ),
      );
    }
    if (status != LoadStatus.success || items.isEmpty) return null;

    final expanded = _expanded.contains(tab);
    final shown = expanded ? items : items.take(_preview).toList();

    return ContentSection(
      title: '$title · $total',
      boxed: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...shown,
          if (!expanded && total > shown.length) ...[
            const SizedBox(height: 6),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _expanded.add(tab)),
                child: Text(l10n.showAllCount(total.toString())),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final caption = [
      if (user.city != null) user.city!.name,
      if (user.countOrders != null)
        l10n.userProfileCompletedOrders(user.countOrders!),
      if (user.createdAt != null)
        l10n.userProfileMemberSince(
            DateFormat('MM.yyyy').format(user.createdAt!)),
    ].join(' · ');

    return Row(
      children: [
        _Avatar(photo: user.photo),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              if (caption.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  caption,
                  style: TextStyle(fontSize: 11.5, color: scheme.secondary),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photo});
  final String? photo;

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      color: scheme.secondaryContainer,
      alignment: Alignment.center,
      child: Icon(Icons.person, size: 32, color: scheme.secondary),
    );

    // Круг, как в профиле, отклике и карточке исполнителя: раньше здесь был
    // единственный на всё приложение квадратный аватар.
    return ClipOval(
      child: SizedBox(
        width: _size,
        height: _size,
        child: photo == null || photo!.isEmpty
            ? placeholder
            : CachedNetworkImage(
                imageUrl: photo!,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, __, ___) => placeholder,
                errorWidget: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}

/// «Позвонить» доступно гостям и обычным пользователям — телефон и так публичен
/// на карточке, — но исполнителю без активной подписки закрыт весь контакт с
/// заказчиком: и звонок, и чат. Это часть платного доступа.
/// «Написать» требует авторизации: ChatCubit.createChat бьётся в
/// защищённый эндпоинт и на 403 разлогинивает, поэтому гостю её не
/// показываем.
///
/// Кнопки переехали из-под шапки в закреплённую панель: раньше они постоянно
/// занимали верх экрана, отнимая место у списков.
class _ContactBar extends StatelessWidget {
  const _ContactBar({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final profile = context.watch<ProfileScreenCubit>().state;
    final isGuest = profile.user == null;
    final executor = profile.user?.executor;
    final contactBlocked = executor != null && !executor.hasActiveSubscription;

    if (user.phone == null && isGuest) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: scheme.tertiary,
        border: Border(top: BorderSide(color: scheme.onTertiary)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (user.phone != null)
                    Expanded(
                      child: ElevatedButtonApp(
                        text: l10n.call,
                        onPressed: contactBlocked
                            ? null
                            : () => launchUrl(
                                Uri(scheme: 'tel', path: user.phone!)),
                      ),
                    ),
                  if (user.phone != null && !isGuest) const SizedBox(width: 8),
                  if (!isGuest)
                    Expanded(
                      child: OutlinedButtonApp(
                        text: l10n.write,
                        // Future запроса — кнопка держит крутилку и не
                        // шлёт второй. Переписку открывает ChatOpenListener.
                        onPressed: contactBlocked
                            ? null
                            : () => context
                                .read<ChatCubit>()
                                .openChatWith(user.id),
                      ),
                    ),
                ],
              ),
              if (contactBlocked) HintText(l10n.contact_requires_subscription),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.actionText, this.onAction});

  final String text;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, size: 32, color: scheme.secondary),
        const SizedBox(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.5, color: scheme.secondary),
        ),
        if (actionText != null && onAction != null) ...[
          const SizedBox(height: 6),
          TextButton(onPressed: onAction, child: Text(actionText!)),
        ],
      ],
    );
  }
}
