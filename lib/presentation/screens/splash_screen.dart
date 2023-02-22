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

  Widget tabTile(BuildContext context, bool isActive) {
    return Icon(Icons.add_shopping_cart_outlined,
      color: isActive? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,

    );
  }

  _handleClick(TabsRouter tabsRouter, int index) => () {
    tabsRouter.setActiveIndex(index);
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
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tab(icon: Icons.add_shopping_cart_outlined,
                    isActive: 0 == tabsRouter.activeIndex,
                    callback: _handleClick(tabsRouter, 0),
                  ),
                  Tab(icon: Icons.store,
                    isActive: 1 == tabsRouter.activeIndex,
                    callback: _handleClick(tabsRouter, 1),

                  ),
                  SizedBox(width: 50,),
                  Tab(icon: Icons.account_balance_wallet_sharp,
                    isActive: 2 == tabsRouter.activeIndex,
                    callback: _handleClick(tabsRouter, 2),

                  ),
                  Tab(icon: Icons.person,
                    isActive: 3 == tabsRouter.activeIndex,
                    callback: _handleClick(tabsRouter, 3),

                  ),
                ],
              )
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.add, color: Theme.of(context).colorScheme.background, size: 40,),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 15,)
              ],
            )
          ],
        );

        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.shifting,
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
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

class Tab extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback callback;

  const Tab({super.key, required this.icon, required this.isActive, required this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(icon,
        color: isActive? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSecondary,
        size:  isActive? 30 : 25,
      ),
      onTap: callback,
    );
  }
}