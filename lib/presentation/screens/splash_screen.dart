import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/add_anything_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_app.dart';



class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  _doubleTap(BuildContext context, PageRouteInfo page) => () {
    context.router.navigate(page);
  };

  _handleClick(TabsRouter tabsRouter, int index) => () {
    tabsRouter.setActiveIndex(index);
  };

  _add(BuildContext context) => () async {
    await showModalBottomSheet(
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
      routes: const [
        OrderRouter(),
        StoreRouter(),
        AdRouter(),
        ProfileRouter(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tab(icon: IconPack.basket ,
                    isActive: 0 == tabsRouter.activeIndex,
                    click: _handleClick(tabsRouter, 0),
                    doubleClick: _doubleTap(context, const InitialRouter(children: [OrderRouter()])),
                  ),
                  Tab(icon: IconPack.market,
                    isActive: 1 == tabsRouter.activeIndex,
                    click: _handleClick(tabsRouter, 1),
                    doubleClick: _doubleTap(context, const InitialRouter(children: [StoreRouter()])),

                  ),
                  const SizedBox(width: 50,),
                  Tab(icon: IconPack.chat,
                    isActive: 2 == tabsRouter.activeIndex,
                    click: _handleClick(tabsRouter, 2),
                    doubleClick: _doubleTap(context, const InitialRouter(children: [AdRouter()])),

                  ),
                  Tab(icon: IconPack.profile,
                    isActive: 3 == tabsRouter.activeIndex,
                    click: _handleClick(tabsRouter, 3),
                    doubleClick: _doubleTap(context, const InitialRouter(children: [ProfileRouter()])),
                  ),
                ],
              )
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: _add(context),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.add, color: Theme.of(context).colorScheme.background, size: 40,),
                ),
                const SizedBox(height: 15,)
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
      onTap: click,
      onDoubleTap: doubleClick,
      child: Icon(icon,
        color: isActive? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSecondary,
        size:  isActive? 30 : 25,
      ),
    );
  }
}