import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/add_anything_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_app.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  _doubleTap(BuildContext context, PageRouteInfo page) => () {
        context.router.navigate(page);
    };

  _handleClick(TabsRouter tabsRouter, int index) => () {
        tabsRouter.setActiveIndex(index);
      };

  _add(BuildContext context) => () async {
        await showModalBottomSheet(
            useRootNavigator: true,
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            elevation: 100,
            builder: (_) => AddAnythingBottomSheet());
      };

  _introStart(BuildContext context) => () async {
    if(await IsFirstRun.isFirstCall()) return;
    Intro.of(context).start();
  };

  @override
  Widget build(BuildContext context) {
    return Intro(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(100),
      maskClosable: true,
      maskColor: const Color.fromRGBO(19, 78, 74, 0.9),
      child: AutoTabsScaffold(
        scaffoldKey: getItApp.get<GlobalKey<ScaffoldState>>(),
        lazyLoad: true,
        drawer: const  DrawerApp(),
        routes: const [
          OrderRouter(),
          StoreRouter(),
          AdRouter(),
          ProfileRouter(),
        ],
        bottomNavigationBuilder: (context, tabsRouter) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                  height: 75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IntroStepBuilder(
                        builder: (context, key) {
                          return Tab(
                            key: key,
                            icon: IconPack.basket,
                            isActive: 0 == tabsRouter.activeIndex,
                            click: _handleClick(tabsRouter, 0),
                            doubleClick: _doubleTap(context,
                                const InitialRouter(children: [OrderRouter()])),
                          );
                        },
                        order: 1,
                        overlayBuilder: (StepWidgetParams params) {
                          return Text('Безусловно, внедрение современных методик предполагает независимые.');
                        },
                        onWidgetLoad: _introStart(context)
                      ),
                      IntroStepBuilder(
                        builder: (context, key) {
                          return Tab(
                            key: key,
                            icon: IconPack.market,
                            isActive: 1 == tabsRouter.activeIndex,
                            click: _handleClick(tabsRouter, 1),
                            doubleClick: _doubleTap(context,
                                const InitialRouter(children: [StoreRouter()])),
                          );
                        },
                        order: 2,
                        overlayBuilder: (StepWidgetParams params) {
                          return Text('Безусловно, внедрение современных методик предполагает независимые.');
                        },
                      ),

                      const SizedBox(
                        width: 50,
                      ),
                      IntroStepBuilder(
                        builder: (context, key) {
                          return Tab(
                            key: key,
                            icon: IconPack.chat,
                            isActive: 2 == tabsRouter.activeIndex,
                            click: _handleClick(tabsRouter, 2),
                            doubleClick: _doubleTap(
                                context, const InitialRouter(children: [AdRouter()])),
                          );
                        },
                        order: 3,
                        overlayBuilder: (StepWidgetParams params) {
                          return Text('Безусловно, внедрение современных методик предполагает независимые.');
                        },
                      ),
                      IntroStepBuilder(
                        builder: (context, key) {
                          return Tab(
                            key: key,
                            icon: IconPack.profile,
                            isActive: 3 == tabsRouter.activeIndex,
                            click: _handleClick(tabsRouter, 3),
                            doubleClick: _doubleTap(context,
                                const InitialRouter(children: [ProfileRouter()])
                            ),
                          );
                        },
                        order: 4,
                        overlayBuilder: (StepWidgetParams params) {
                          return Text('Безусловно, внедрение современных методик предполагает независимые.');
                        },
                      ),
                    ],
                  )),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    onPressed: _add(context),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.background,
                      size: 40,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              )
            ],
          );
        },
      )
    );
  }
}

class Tab extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback click;
  final VoidCallback doubleClick;

  const Tab(
      {super.key,
      required this.icon,
      required this.isActive,
      required this.click,
      required this.doubleClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: click,
      onDoubleTap: doubleClick,
      child: Icon(
        icon,
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSecondary,
        size: isActive ? 30 : 25,
      ),
    );
  }
}
