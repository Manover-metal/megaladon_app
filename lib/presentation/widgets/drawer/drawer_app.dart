import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/orders/badges/order_badges_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_route_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_tile.dart';

/// Боковое меню. Плотный список: строка профиля сверху, пункты по 40 px с
/// иконками, «Выход» прижат к низу и не уезжает вместе с прокруткой.
class DrawerApp extends StatelessWidget {
  const DrawerApp({super.key});

  Null Function() _login(BuildContext context) => () {
        context.router.push(const LoginRoute());
      };

  Null Function() _registerUser(BuildContext context) => () {
        context.router.push(const RegisterUserRoute());
      };

  Null Function() _logout(BuildContext context) => () {
        // Только диспатчим событие. Переход на логин делает реактивный
        // BlocListener в SplashScreen после прихода AuthLogoutState — иначе
        // ловим гонку с NotAuthGuard и ломаем стек навигации.
        context.read<AuthBloc>().add(AuthLogoutEvent());
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) => authState is AuthLoginState
                  ? const _ProfileRow()
                  : _GuestHeader(
                      onLogin: _login(context),
                      onRegister: _registerUser(context),
                    ),
            ),
            _Hair(color: scheme.onTertiary),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        if (authState is! AuthLoginState) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            // Заказы, где с последнего просмотра сменился
                            // статус или прибавились отклики — обе вкладки
                            // экрана сразу.
                            BlocBuilder<OrderBadgesCubit, OrderBadgesState>(
                              builder: (context, badgesState) =>
                                  DrawerRouteTile(
                                icon: Icons.assignment_outlined,
                                text: l10n.my_orders,
                                badgeCount: badgesState.badges.total,
                                activeRouteName: ListMyOrdersRoute.name,
                                page: const InitialRouter(
                                  children: [
                                    OrderRouter(children: [ListMyOrdersRoute()])
                                  ],
                                ),
                              ),
                            ),
                            DrawerRouteTile(
                              icon: Icons.local_offer_outlined,
                              text: l10n.my_announcement,
                              activeRouteName: MyAdsRoute.name,
                              page: const InitialRouter(
                                children: [
                                  AdRouter(children: [MyAdsRoute()])
                                ],
                              ),
                            ),
                            DrawerRouteTile(
                              icon: Icons.people_outline,
                              text: l10n.my_executor,
                              activeRouteName: ListMyExecutorsRoute.name,
                              page: const InitialRouter(
                                children: [
                                  OrderRouter(
                                      children: [ListMyExecutorsRoute()])
                                ],
                              ),
                            ),
                            // Счётчик берём из ChatCubit: он опрашивает
                            // список чатов и вне их экрана, поэтому бейдж
                            // здесь не устаревает.
                            BlocBuilder<ChatCubit, ChatState>(
                              builder: (context, chatState) => DrawerRouteTile(
                                icon: IconPack.chat,
                                text: l10n.chats,
                                badgeCount: chatState.totalUnread,
                                activeRouteName: ListChatsRoute.name,
                                page: const InitialRouter(
                                  children: [
                                    ProfileRouter(children: [ListChatsRoute()])
                                  ],
                                ),
                              ),
                            ),
                            // Экран подписок состоит из вкладок «как
                            // исполнитель» и «как магазин»: без этих
                            // сущностей у пользователя там ноль вкладок и
                            // пустой экран. Поэтому и пункт меню прячем.
                            BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                              builder: (context, profileState) {
                                final hasFace =
                                    profileState.user?.executor != null ||
                                        profileState.user?.store != null;

                                if (!hasFace) return const SizedBox.shrink();

                                return DrawerRouteTile(
                                  icon: Icons.workspace_premium_outlined,
                                  text: l10n.subscriptions,
                                  activeRouteName: SubscribeRoute.name,
                                  page:  InitialRouter(
                                    children: [
                                      OrderRouter(children: [SubscribeRoute()])
                                    ],
                                  ),
                                );
                              },
                            ),
                            _Hair(color: scheme.onTertiary, inset: true),
                          ],
                        );
                      },
                    ),
                    // Иконки те же, что у вкладок нижней панели, — раздел
                    // узнаётся одинаково и оттуда, и отсюда.
                    DrawerRouteTile(
                      icon: IconPack.basket,
                      text: l10n.orders,
                      activeRouteName: ListOrdersRoute.name,
                      page: const InitialRouter(children: [OrderRouter()]),
                    ),
                    DrawerRouteTile(
                      icon: IconPack.market,
                      text: l10n.theshops,
                      activeRouteName: ListStoresRoute.name,
                      page: const InitialRouter(children: [StoreRouter()]),
                    ),
                    DrawerRouteTile(
                      icon: Icons.account_balance_wallet_outlined,
                      text: l10n.marketplace,
                      activeRouteName: TradingAdsRoute.name,
                      page: const InitialRouter(children: [AdRouter()]),
                    ),
                    _Hair(color: scheme.onTertiary, inset: true),
                    BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                      builder: (context, state) {
                        final user = state.user;

                        return Column(
                          children: [
                            // Вторую роль заводят поверх аккаунта: без входа
                            // формы регистрации исполнителя и магазина
                            // заполнять нечем. Раньше условие смотрело только
                            // на user?.executor, и у гостя — где user сам по
                            // себе null — обе кнопки показывались.
                            if (user != null && user.executor == null)
                              DrawerRouteTile(
                                icon: Icons.person_add_outlined,
                                text: l10n.artist_registration,
                                muted: true,
                                page: const RegisterExecutorRoute(),
                              ),
                            if (user != null && user.store == null)
                              DrawerRouteTile(
                                icon: Icons.add_business_outlined,
                                text: l10n.shop_registration,
                                muted: true,
                                page: const RegisterStoreRoute(),
                              ),
                          ],
                        );
                      },
                    ),
                    DrawerRouteTile(
                      icon: IconPack.settings,
                      text: l10n.settings,
                      activeRouteName: SettingsRoute.name,
                      page: const InitialRouter(children: [
                        ProfileRouter(children: [SettingsRoute()])
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is! AuthLoginState) return const SizedBox.shrink();

                return Column(
                  children: [
                    _Hair(color: scheme.onTertiary),
                    DrawerTile(
                      icon: Icons.logout,
                      text: l10n.exit,
                      muted: true,
                      callback: _logout(context),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Кто вошёл: аватар, имя, телефон. До сих пор меню начиналось с пустого
/// отступа, и понять это было неоткуда.
class _ProfileRow extends StatelessWidget {
  const _ProfileRow();

  Null Function() _toProfile(BuildContext context) => () {
        context.router.pop();
        context.router.navigate(const InitialRouter(children: [
          ProfileRouter(),
        ]));
      };

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final user = state.user;

          return InkWell(
            onTap: _toProfile(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  _Avatar(user: user),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        if (user?.phone != null)
                          Text(
                            user!.phone!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: theme.colorScheme.secondary),
                ],
              ),
            ),
          );
        },
      );
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});
  final UserModel? user;

  /// Инициалы из имени: «Асхат Кенжебаев» → «АК». Фотография есть далеко не
  /// у всех, а пустой серый круг ничего не говорит.
  String get _initials {
    final parts = (user?.name ?? '')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList();

    return parts.map((part) => part[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final photo = user?.photo;

    return ClipOval(
      child: Container(
        width: 36,
        height: 36,
        color: scheme.secondaryContainer,
        alignment: Alignment.center,
        child: photo != null && photo.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: photo,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _InitialsText(_initials),
                progressIndicatorBuilder: (_, __, ___) =>
                    _InitialsText(_initials),
              )
            : _InitialsText(_initials),
      ),
    );
  }
}

class _InitialsText extends StatelessWidget {
  const _InitialsText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}

/// Гость: вместо строки профиля — вход и регистрация. Обычными пунктами
/// меню, а не кнопками старого дизайна: список читается единым ритмом.
class _GuestHeader extends StatelessWidget {
  const _GuestHeader({required this.onLogin, required this.onRegister});
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          DrawerTile(
            icon: Icons.login,
            text: l10n.sign_in,
            callback: onLogin,
          ),
          // Та же подпись, что на экране входа: «Создать аккаунт».
          DrawerTile(
            icon: Icons.person_add_alt_outlined,
            text: l10n.create_account,
            callback: onRegister,
          ),
        ],
      ),
    );
  }
}

class _Hair extends StatelessWidget {
  const _Hair({required this.color, this.inset = false});
  final Color color;

  /// Разделитель внутри списка — с отступами, чтобы не резать меню на части.
  final bool inset;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: inset ? 16 : 0, vertical: inset ? 6 : 0),
        child: Container(height: 1, color: color),
      );
}
