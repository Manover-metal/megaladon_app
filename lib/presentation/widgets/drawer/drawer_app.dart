import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  _registerShop(BuildContext context) => () {
    context.router.push(const RegisterShopRoute());

  };

  _logout () {}

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ...[
              ElevatedButtonApp(
                text: 'Войти',
                onPressed: _login(context),
              ),
              OutlinedButtonApp(
                text: 'Регистрация',
                onPressed: _registerUser(context),
              ),
            ],
            ...[
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
            ...[
              DrawerRouteTile(text: 'Заказы', page: InitialRouter(children: [OrderRouter()]),),
              DrawerRouteTile(text: 'Магазины', page: InitialRouter(children: [ShopRouter()]),),
              DrawerRouteTile(text: 'Торговая площадка', page: InitialRouter(children: [AdRouter()]),),
              Divider(thickness: 1,)
            ],
            DrawerTile(text: 'Выход', callback: _logout),
            Spacer(),
            ...[
              ElevatedButtonApp(
                text: 'Регистрация исполнителя',
                onPressed: _registerExecutor(context),
              ),
              OutlinedButtonApp(
                text: 'Регистрация магазина',
                onPressed: _registerShop(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

}