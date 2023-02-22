import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/add_anything_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_app.dart';

class SplashScreen extends StatelessWidget {

  _doubleTap(BuildContext context, PageRouteInfo page) => () {
    context.router.navigate(page);
  };

  _handleClick(TabsRouter tabsRouter, int index) => () {
    tabsRouter.setActiveIndex(index);
  };

  _add(BuildContext context) => () async {
    bool? result = await showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => AddAnythingBottomSheet()
    );
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
                    click: _handleClick(tabsRouter, 0),
                    doubleClick: _doubleTap(context, InitialRouter(children: [OrderRouter()])),
                  ),
                  Tab(icon: Icons.store,
                    isActive: 1 == tabsRouter.activeIndex,
                    click: _handleClick(tabsRouter, 1),
                    doubleClick: _doubleTap(context, InitialRouter(children: [StoreRouter()])),

                  ),
                  SizedBox(width: 50,),
                  Tab(icon: Icons.account_balance_wallet_sharp,
                    isActive: 2 == tabsRouter.activeIndex,
                    click: _handleClick(tabsRouter, 2),
                    doubleClick: _doubleTap(context, InitialRouter(children: [AdRouter()])),

                  ),
                  Tab(icon: Icons.person,
                    isActive: 3 == tabsRouter.activeIndex,
                    click: _handleClick(tabsRouter, 3),
                    doubleClick: _doubleTap(context, InitialRouter(children: [ProfileRouter()])),
                  ),
                ],
              )
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: _add(context),
                  child: Icon(Icons.add, color: Theme.of(context).colorScheme.background, size: 40,),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 15,)
              ],
            )
          ],
        );
      },
    );
  }
}

class Tab extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback click;
  final VoidCallback doubleClick;

  const Tab({super.key, required this.icon, required this.isActive, required this.click, required this.doubleClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(icon,
        color: isActive? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSecondary,
        size:  isActive? 30 : 25,
      ),
      onTap: click,
      onDoubleTap: doubleClick,
    );
  }
}