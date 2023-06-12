import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollControllerExecutor;
  late ScrollController _scrollControllerStore;
  late TabController _tabController;



  @override
  void initState() {
    if(_isExecutor()) {
      _scrollControllerStore = ScrollController();
    }
    if(_isStore()) {
      _scrollControllerExecutor = ScrollController();
    }
    _tabController = TabController(length: _countFace(), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    if(_isExecutor()) {
      _scrollControllerExecutor.dispose();
    }
    if(_isStore()) {
      _scrollControllerStore.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }

  bool _isExecutor() {
    return context.read<AuthBloc>().hasExecutor();
  }

  bool _isStore() {
    return context.read<AuthBloc>().hasStore();
  }

  int _countFace() {
    int countFace = 0;
    if(_isExecutor()) {
      countFace++;
    }
    if(_isStore()) {
      countFace++;
    }
    return countFace;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return DefaultTabController(
          length: _countFace(),
          child: Scaffold(
            body: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool isBool) {
                  return [
                    SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: HeaderAppBar(isMenu: true, title: "Подписки".tr()),
                            ),
                          ],
                        )
                    ),
                    SliverPersistentHeader(
                        delegate: TabBarDelegate(
                          TabBar(
                            controller: _tabController,
                            labelColor: Theme.of(context).colorScheme.primary,
                            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Theme.of(context).colorScheme.primary,
                            tabs:  [
                              if(_isExecutor()) Tab(text:"Как исполнителя".tr()),
                              if(_isStore()) Tab(text: "Как магазина".tr()),
                            ],
                          ),
                        )
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    if(_isExecutor()) CupertinoScrollbar(
                      controller: _scrollControllerExecutor,
                      child: SingleChildScrollView(
                        controller: _scrollControllerExecutor,
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: BlocBuilder<DictionaryCubit, DictionaryState>(
                            builder: (context, state) {

                              return Column(
                                children: state.subscribesExecutor.map((e) {
                                  return Container(
                                    child: Text(e.price.toString()),
                                  );
                                }).toList()
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    if(_isStore()) CupertinoScrollbar(
                      controller: _scrollControllerStore,
                      child: SingleChildScrollView(
                        controller: _scrollControllerStore,
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: BlocBuilder<DictionaryCubit, DictionaryState>(
                            builder: (context, state) {
                              return Column(
                                children: state.subscribesStore.map((e) {
                                  return Container(
                                    child: Text(e.price.toString()),
                                  );
                                }).toList()
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        child: tabBar
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}
