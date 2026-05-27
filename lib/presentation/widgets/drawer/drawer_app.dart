

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intro/flutter_intro.dart';
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
    print('executor');

    context.router.navigate(const RegisterExecutorRoute());
  };

  _registerStore(BuildContext context) => () {
    print('store');
    context.router.navigate(const RegisterStoreRoute());
  };

  _logout(BuildContext context) => () {
    context.read<AuthBloc>().add(AuthLogoutEvent());
    context.router.replaceAll([const LoginRoute()]);
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, state) {
                return Column(
                  children: [
                    Visibility(
                        visible: state is! AuthLoginState,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ElevatedButtonApp(
                                text: 'Sign_in'.tr(),
                                onPressed: _login(context),
                              ),
                              OutlinedButtonApp(
                                text: 'Registration'.tr(),
                                onPressed: _registerUser(context),
                              ),
                            ],
                          ),
                        )
                    ),

                    Visibility(
                        visible: state is AuthLoginState,
                        child: Column(
                          children: [
                            DrawerRouteTile(
                              text: 'My_orders'.tr(),
                              page: const InitialRouter(
                                children: [
                                  OrderRouter(children: [ListMyOrdersRoute()])
                                ],
                              ),
                            ),
                            DrawerRouteTile(
                              text:"My_announcement".tr(),
                              page: const  InitialRouter(
                                children: [
                                  AdRouter(children: [MyAdsRoute()])
                                ],
                              ),
                            ),
                            DrawerRouteTile(
                              text: "Executor".tr(),
                              page: const InitialRouter(
                                children: [
                                  OrderRouter(children: [ListMyExecutorsRoute()])
                                ],
                              ),
                            ),
                            DrawerRouteTile(
                              text: "Chats".tr(),
                              page: const InitialRouter(
                                children: [
                                  ProfileRouter(children: [ListChatsRoute()])
                                ],
                              ),
                            ),
                            DrawerRouteTile(
                              text: "Подписки".tr(),
                              page: const InitialRouter(
                                children: [
                                  OrderRouter(children: [SubscribeRoute()])
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                  ]
                );
              }
            ),
            ...[
              DrawerRouteTile(

                text: "Orders".tr(),
                page: const InitialRouter(children: [OrderRouter()]),
              ),
              DrawerRouteTile(
                text: "Theshops".tr(),
                page: const InitialRouter(children: [StoreRouter()]),
              ),
               DrawerRouteTile(
                text: 'Marketplace'.tr(),
                page: InitialRouter(children: [AdRouter()]),
              ),
               DrawerRouteTile(
                text: 'Settings'.tr(),
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
                  return DrawerTile(text: 'exit'.tr(), callback: _logout(context));
                } else {
                  return Container();
                }
              },
            ),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      if(state is AuthLoginState) ...[

                        if(state.auth.executor.value == null) ElevatedButtonApp(
                          text: 'Artist_registration'.tr(),
                          onPressed: _registerExecutor(context),
                        ),
                        if(state.auth.store.value == null)  ElevatedButtonApp(
                          text: 'Shop_registration'.tr(),
                          onPressed: _registerStore(context),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
