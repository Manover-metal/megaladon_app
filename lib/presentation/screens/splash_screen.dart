import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_app.dart';

class SplashScreen extends StatelessWidget {

  _doubleTap(BuildContext context, PageRouteInfo page) => () {
    context.router.navigate(page);
  };

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      scaffoldKey: getItApp.get<GlobalKey<ScaffoldState>>(),
      drawer: DrawerApp(),
      lazyLoad: true,
      routes: [
        OrderRouter(),
        StoreRouter(),
        AdRouter(),
        ProfileRouter(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(

          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                child: Icon(Icons.add_shopping_cart_outlined),
                onDoubleTap: _doubleTap(context, const OrderRouter()),
              ),
              label: 'Заказы',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                child: Icon(Icons.store),
                onDoubleTap: _doubleTap(context, const StoreRouter()),
              ),
              label: 'Магазины',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                  child: Icon(Icons.account_balance_wallet_sharp),
                onDoubleTap: _doubleTap(context, const AdRouter()),
              ),
              label: 'Объявления',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                child: Icon(Icons.person),
                onDoubleTap: _doubleTap(context, const ProfileRouter()),
              ),
              label: 'Профиль',
            ),
          ],
        );
      },
    );
  }
}