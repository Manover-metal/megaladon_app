

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_route_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_tile.dart';
import 'package:megaladon/generated/locale_keys.g.dart';

class DrawerApp extends StatelessWidget {
  const DrawerApp({super.key});

  _login(BuildContext context) => () {
    context.router.push(const LoginRoute());
  };

  _registerUser(BuildContext context) => () {
    context.router.push(const RegisterUserRoute());
  };

  _registerExecutor(BuildContext context) => () {
    context.router.push(const RegisterExecutorRoute());
  };

  _registerStore(BuildContext context) => () {
    context.router.push(const RegisterStoreRoute());
  };

  _logout(BuildContext context) => () {
    context.read<AuthBloc>().add(AuthLogoutEvent());
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 20,),
                    if(state is! AuthLoginState)...[
                      ElevatedButtonApp(
                        text: 'Войти',
                        onPressed: _login(context),
                      ),
                      OutlinedButtonApp(
                        text: 'Регистрация',
                        onPressed: _registerUser(context),
                      ),
                    ]
                    else ...[
                      const DrawerRouteTile(
                        text: 'Мои заказы',
                        page: InitialRouter(
                          children: [
                            OrderRouter(children: [ListMyOrdersRoute()])
                          ],
                        ),
                      ),
                      const DrawerRouteTile(
                        text: 'Мои объявления',
                        page: InitialRouter(
                          children: [
                            AdRouter(children: [MyAdsRoute()])
                          ],
                        ),
                      ),
                      const DrawerRouteTile(
                        text: 'Мои исполнители',
                        page: InitialRouter(children: [
                          ProfileRouter(children: [ListExecutorRoute()])]
                        ),
                      ),
                      const DrawerRouteTile(
                        text: 'Чат',
                        page: InitialRouter(children: [
                          ProfileRouter(children: [ListChatsRoute()])
                        ]),
                      ),
                      const Divider(
                        thickness: 1,
                      )
                    ],
                  ]
                );
              }
            ),
            ...[
              DrawerRouteTile(
                
                text: LocaleKeys.Orders.tr(),
                page: const InitialRouter(children: [OrderRouter()]),
              ),
              DrawerRouteTile(
                text: LocaleKeys.Theshops.tr(),
                page: const InitialRouter(children: [StoreRouter()]),
              ),
              const DrawerRouteTile(
                text: 'Торговая площадка',
                page: InitialRouter(children: [AdRouter()]),
              ),
              //Create_ratkum
              const DrawerRouteTile(
                text: 'Настройки',
                page: InitialRouter(children: [
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
                  return DrawerTile(text: 'Выход', callback: _logout(context));
                } else {
                  return Container();
                }
              },
            ),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Column(
                  children: [
                    if(state is AuthLoginState) ...[

                      if(state.auth.executor.value == null) ElevatedButtonApp(
                        text: 'Регистрация исполнителя',
                        onPressed: _registerExecutor(context),
                      ),
                      if(state.auth.store.value == null)  OutlinedButtonApp(
                        text: 'Регистрация магазина',
                        onPressed: _registerStore(context),
                      ),
                    ],
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
