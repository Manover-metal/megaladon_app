import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/orders/badges/order_badges_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_route_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_tile.dart';

class DrawerApp extends StatelessWidget {
  const DrawerApp({super.key});

  Null Function() _login(BuildContext context) => () {
        context.router.push(const LoginRoute());
      };

  Null Function() _registerUser(BuildContext context) => () {
        context.router.push(const RegisterUserRoute());
      };

  Null Function() _registerExecutor(BuildContext context) => () {
        print('executor');

        context.router.navigate(const RegisterExecutorRoute());
      };

  Null Function() _registerStore(BuildContext context) => () {
        print('store');
        context.router.navigate(const RegisterStoreRoute());
      };

  Null Function() _logout(BuildContext context) => () {
        // Только диспатчим событие. Переход на логин делает реактивный
        // BlocListener в SplashScreen после прихода AuthLogoutState — иначе
        // ловим гонку с NotAuthGuard и ломаем стек навигации.
        context.read<AuthBloc>().add(AuthLogoutEvent());
      };

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) => Column(children: [
                        Visibility(
                            visible: state is! AuthLoginState,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  ElevatedButtonApp(
                                    text: AppLocalizations.of(context)!.sign_in,
                                    onPressed: _login(context),
                                  ),
                                  OutlinedButtonApp(
                                    text: AppLocalizations.of(context)!
                                        .registration,
                                    onPressed: _registerUser(context),
                                  ),
                                ],
                              ),
                            )),
                        Visibility(
                            visible: state is AuthLoginState,
                            child: Column(
                              children: [
                                // Заказы, где с последнего просмотра сменился
                                // статус или прибавились отклики — обе вкладки
                                // экрана сразу.
                                BlocBuilder<OrderBadgesCubit,
                                    OrderBadgesState>(
                                  builder: (context, badgesState) =>
                                      DrawerRouteTile(
                                    text:
                                        AppLocalizations.of(context)!.my_orders,
                                    badgeCount: badgesState.badges.total,
                                    page: const InitialRouter(
                                      children: [
                                        OrderRouter(
                                            children: [ListMyOrdersRoute()])
                                      ],
                                    ),
                                  ),
                                ),
                                DrawerRouteTile(
                                  text: AppLocalizations.of(context)!
                                      .my_announcement,
                                  page: const InitialRouter(
                                    children: [
                                      AdRouter(children: [MyAdsRoute()])
                                    ],
                                  ),
                                ),
                                DrawerRouteTile(
                                  text:
                                      AppLocalizations.of(context)!.my_executor,
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
                                  builder: (context, chatState) =>
                                      DrawerRouteTile(
                                    text: AppLocalizations.of(context)!.chats,
                                    badgeCount: chatState.totalUnread,
                                    page: const InitialRouter(
                                      children: [
                                        ProfileRouter(
                                            children: [ListChatsRoute()])
                                      ],
                                    ),
                                  ),
                                ),
                                // Экран подписок состоит из вкладок «как
                                // исполнитель» и «как магазин»: без этих
                                // сущностей у пользователя там ноль вкладок и
                                // пустой экран. Поэтому и пункт меню прячем.
                                BlocBuilder<ProfileScreenCubit,
                                    ProfileScreenState>(
                                  builder: (context, profileState) {
                                    final hasFace =
                                        profileState.user?.executor != null ||
                                            profileState.user?.store != null;

                                    if (!hasFace) {
                                      return const SizedBox.shrink();
                                    }

                                    return DrawerRouteTile(
                                      text: AppLocalizations.of(context)!
                                          .subscriptions,
                                      page: const InitialRouter(
                                        children: [
                                          OrderRouter(
                                              children: [SubscribeRoute()])
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )),
                        const Divider(
                          thickness: 1,
                        ),
                      ])),
              ...[
                DrawerRouteTile(
                  text: AppLocalizations.of(context)!.orders,
                  page: const InitialRouter(children: [OrderRouter()]),
                ),
                DrawerRouteTile(
                  text: AppLocalizations.of(context)!.theshops,
                  page: const InitialRouter(children: [StoreRouter()]),
                ),
                DrawerRouteTile(
                  text: AppLocalizations.of(context)!.marketplace,
                  page: const InitialRouter(children: [AdRouter()]),
                ),
                DrawerRouteTile(
                  text: AppLocalizations.of(context)!.settings,
                  page: const InitialRouter(children: [
                    ProfileRouter(children: [SettingsRoute()])
                  ]),
                ),
                const Divider(
                  thickness: 1,
                )
              ],
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoginState) {
                    return DrawerTile(
                        text: AppLocalizations.of(context)!.exit,
                        callback: _logout(context));
                  } else {
                    return Container();
                  }
                },
              ),
              const Spacer(),
              BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                builder: (context, state) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (state.user?.executor == null)
                        ElevatedButtonApp(
                          text:
                              AppLocalizations.of(context)!.artist_registration,
                          onPressed: _registerExecutor(context),
                        ),
                      if (state.user?.store == null)
                        ElevatedButtonApp(
                          text: AppLocalizations.of(context)!.shop_registration,
                          onPressed: _registerStore(context),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
