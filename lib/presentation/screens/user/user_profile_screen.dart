import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/logic/screens/user/user_profile_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/text/hint_text.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({required this.userId, super.key});

  final int userId;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => UserProfileCubit(userId)..loadProfile(),
        child: const _UserProfileView(),
      );
}

class _UserProfileView extends StatefulWidget {
  const _UserProfileView();

  @override
  State<_UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<_UserProfileView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: UserProfileTab.values.length, vsync: this)
        ..addListener(_onTabChanged);

  @override
  void initState() {
    super.initState();
    // Первая вкладка не вызывает listener — грузим её явно.
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrentTab());
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _loadCurrentTab();
  }

  void _loadCurrentTab() {
    context
        .read<UserProfileCubit>()
        .loadTab(UserProfileTab.values[_tabController.index]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.userProfileTitle)),
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state.profileStatus == LoadStatus.loading ||
              state.profileStatus == LoadStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.profileStatus == LoadStatus.error || state.user == null) {
            return _CenteredMessage(
              text: l10n.userProfileNotFound,
              actionText: l10n.userProfileRetry,
              onAction: () => context.read<UserProfileCubit>().loadProfile(),
            );
          }

          final user = state.user!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child: CachedNetworkImage(
                          imageUrl: user.photo ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.person, size: 40),
                          progressIndicatorBuilder: (_, __, ___) =>
                              const Icon(Icons.person, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name,
                              style: Theme.of(context).textTheme.titleMedium),
                          if (user.city != null) Text(user.city!.name),
                          if (user.countOrders != null)
                            Text(l10n
                                .userProfileCompletedOrders(user.countOrders!)),
                          if (user.createdAt != null)
                            Text(l10n.userProfileMemberSince(
                                DateFormat('MM.yyyy').format(user.createdAt!))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _ContactButtons(user: user),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: l10n.userProfileTabAdverts),
                  Tab(text: l10n.userProfileTabServices),
                  Tab(text: l10n.userProfileTabOrders),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _TabContent(
                      tab: UserProfileTab.adverts,
                      itemCount: state.adverts.length,
                      itemBuilder: (context, i) =>
                          ListTile(title: Text(state.adverts[i].title)),
                    ),
                    _TabContent(
                      tab: UserProfileTab.services,
                      itemCount: state.services.length,
                      itemBuilder: (context, i) =>
                          ListTile(title: Text(state.services[i].title)),
                    ),
                    _TabContent(
                      tab: UserProfileTab.orders,
                      itemCount: state.orders.length,
                      itemBuilder: (context, i) =>
                          ListTile(title: Text(state.orders[i].title)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
class _ContactButtons extends StatelessWidget {
  const _ContactButtons({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<ProfileScreenCubit>().state;
    final isGuest = profile.user == null;
    final executor = profile.user?.executor;
    final contactBlocked = executor != null && !executor.hasActiveSubscription;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              if (user.phone != null)
                Expanded(
                  child: ElevatedButtonApp(
                    text: l10n.call,
                    onPressed: contactBlocked
                        ? null
                        : () =>
                            launchUrl(Uri(scheme: 'tel', path: user.phone!)),
                  ),
                ),
              if (user.phone != null && !isGuest) const SizedBox(width: 12),
              if (!isGuest)
                Expanded(
                  child: OutlinedButtonApp(
                    text: l10n.write,
                    onPressed: contactBlocked
                        ? null
                        : () => context
                                .read<ChatCubit>()
                                .createChat(user.id)
                                .then((chat) {
                              // context.mounted — аналог проверки !mounted из
                              // _toChat в details_ad_screen: экран могли
                              // закрыть, пока создавался чат.
                              if (chat == null || !context.mounted) return;
                              context.router
                                  .push(DetailsChatRouter(chat: chat));
                            }),
                  ),
                ),
            ],
          ),
          if (contactBlocked) HintText(l10n.contact_requires_subscription),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.tab,
    required this.itemCount,
    required this.itemBuilder,
  });

  final UserProfileTab tab;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        switch (state.statusOf(tab)) {
          case LoadStatus.initial:
          case LoadStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case LoadStatus.error:
            return _CenteredMessage(
              text: l10n.userProfileLoadError,
              actionText: l10n.userProfileRetry,
              onAction: () => context.read<UserProfileCubit>().retryTab(tab),
            );
          case LoadStatus.success:
            if (itemCount == 0) {
              return _CenteredMessage(text: l10n.userProfileEmpty);
            }
            return ListView.builder(
                itemCount: itemCount, itemBuilder: itemBuilder);
        }
      },
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.text, this.actionText, this.onAction});

  final String text;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 12),
              TextButton(onPressed: onAction, child: Text(actionText!)),
            ],
          ],
        ),
      );
}
