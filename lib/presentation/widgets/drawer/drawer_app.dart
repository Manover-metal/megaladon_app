import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_route_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_tile.dart';

class DrawerApp extends StatelessWidget {

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

  _logout (BuildContext context) => () {
    context.read<AuthBloc>().add(AuthLogoutEvent());
  };

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, state) {
                return Column(
                  children: [
                    if(state is! AuthLoginState)...[
                      ElevatedButtonApp(
                        text: 'Войти',
                        onPressed: _login(context),
                      ),
                      OutlinedButtonApp(
                        text: 'Регистрация',
                        onPressed: _registerUser(context),
                      ),
                    ],
                    if(state is AuthLoginState) ...[
                      DrawerRouteTile(text: 'Мои заказы', page: InitialRouter(
                        children: [
                          OrderRouter(children: [ListMyOrdersRoute()])
                        ],
                      ),
                      ),
                      DrawerRouteTile(text: 'Мои объявления', page: InitialRouter(
                        children: [
                          AdRouter(children: [MyAdsRoute()])
                        ],
                      ),
                      ),
                      Divider(thickness: 1,)
                    ],
                  ],
                );
              }
            ),

            ...[
              DrawerRouteTile(text: 'Заказы', page: InitialRouter(children: [OrderRouter()]),),
              DrawerRouteTile(text: 'Магазины', page: InitialRouter(children: [StoreRouter()]),),
              DrawerRouteTile(text: 'Торговая площадка', page: InitialRouter(children: [AdRouter()]),),
              Divider(thickness: 1,)
            ],
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if(state is AuthLoginState) {
                  return DrawerTile(text: 'Выход', callback: _logout(context));
                } else {
                  return Container();
                }
              },
            ),
            Spacer(),
            ...[
              ElevatedButtonApp(
                text: 'Регистрация исполнителя',
                onPressed: _registerExecutor(context),
              ),
              OutlinedButtonApp(
                text: 'Регистрация магазина',
                onPressed: _registerStore(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

}