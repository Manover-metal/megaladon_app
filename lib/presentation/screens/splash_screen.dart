import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/add_anything_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Null Function() _doubleTap(BuildContext context, PageRouteInfo page) => () {
        context.router.navigate(page);
      };

  Null Function() _handleClick(TabsRouter tabsRouter, int index) => () {
        tabsRouter.setActiveIndex(index);
      };

  Future<void> Function() _add(BuildContext context) => () async {
        await showModalBottomSheet(
            useRootNavigator: true,
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            elevation: 100,
            builder: (_) => const AddAnythingBottomSheet());
      };

  Future<void> Function() _introStart(BuildContext context) => () async {
        if (await IsFirstRun.isFirstCall()) Intro.of(context).start();
      };

  void listenFB() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      if (!mounted) return;

      /// TODO: handle notification
      // context.router.navigate(InitialRouter(children: [
      //   OrderRouter(
      //       children: [DetailsOrderRoute(orderId: message.data['order_id'])])
      // ]));
    });

    FirebaseMessaging.onMessage.listen((message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) => Intro(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(100),
      maskClosable: true,
      maskColor: const Color.fromRGBO(19, 78, 74, 0.9),
      child: AutoTabsScaffold(
        scaffoldKey: getItApp.get<GlobalKey<ScaffoldState>>(),
        lazyLoad: true,
        drawer: const DrawerApp(),
        routes: const [
          OrderRouter(),
          StoreRouter(),
          AdRouter(),
          ProfileRouter(),
        ],
        bottomNavigationBuilder: (context, tabsRouter) => SafeArea(
          top: false,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IntroStepBuilder(
                          builder: (context, key) => Tab(
                                key: key,
                                icon: IconPack.basket,
                                isActive: 0 == tabsRouter.activeIndex,
                                click: _handleClick(tabsRouter, 0),
                                doubleClick: _doubleTap(
                                    context,
                                    const InitialRouter(
                                        children: [OrderRouter()])),
                              ),
                          order: 1,
                          overlayBuilder: (params) =>
                              Text(AppLocalizations.of(context)!.introOrders),
                          onWidgetLoad: _introStart(context)),
                      IntroStepBuilder(
                        builder: (context, key) => Tab(
                          key: key,
                          icon: IconPack.market,
                          isActive: 1 == tabsRouter.activeIndex,
                          click: _handleClick(tabsRouter, 1),
                          doubleClick: _doubleTap(context,
                              const InitialRouter(children: [StoreRouter()])),
                        ),
                        order: 2,
                        overlayBuilder: (params) =>
                            Text(AppLocalizations.of(context)!.introStores),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      IntroStepBuilder(
                        builder: (context, key) => Tab(
                          key: key,
                          icon: Icons.account_balance_wallet_outlined,
                          isActive: 2 == tabsRouter.activeIndex,
                          click: _handleClick(tabsRouter, 2),
                          doubleClick: _doubleTap(context,
                              const InitialRouter(children: [AdRouter()])),
                        ),
                        order: 3,
                        overlayBuilder: (params) =>
                            Text(AppLocalizations.of(context)!.introAds),
                      ),
                      IntroStepBuilder(
                        builder: (context, key) => Tab(
                          key: key,
                          icon: IconPack.profile,
                          isActive: 3 == tabsRouter.activeIndex,
                          click: _handleClick(tabsRouter, 3),
                          doubleClick: _doubleTap(context,
                              const InitialRouter(children: [ProfileRouter()])),
                        ),
                        order: 4,
                        overlayBuilder: (params) =>
                            Text(AppLocalizations.of(context)!.introProfile),
                      ),
                    ],
                  )),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FloatingActionButton(
                    onPressed: _add(context),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.surface,
                      size: 40,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ));
}

class Tab extends StatelessWidget {
  const Tab(
      {required this.icon,
      required this.isActive,
      required this.click,
      required this.doubleClick,
      super.key});
  final IconData icon;
  final bool isActive;
  final VoidCallback click;
  final VoidCallback doubleClick;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: click,
        onDoubleTap: doubleClick,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSecondary,
            size: 25,
          ),
        ),
      );
}
