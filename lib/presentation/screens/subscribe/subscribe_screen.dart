import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';
import 'package:megaladon/presentation/widgets/card/subscribe_card.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollControllerExecutor;
  late ScrollController _scrollControllerStore;
  late TabController _tabController;

  @override
  void initState() {
    if (_isExecutor()) {
      _scrollControllerExecutor = ScrollController();
    }
    if (_isStore()) {
      _scrollControllerStore = ScrollController();
    }
    _tabController = TabController(length: _countFace(), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    if (_isExecutor()) {
      _scrollControllerExecutor.dispose();
    }
    if (_isStore()) {
      _scrollControllerStore.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }

  bool _isExecutor() => context.read<AuthBloc>().hasExecutor();

  bool _isStore() => context.read<AuthBloc>().hasStore();

  int _countFace() {
    var countFace = 0;
    if (_isExecutor()) {
      countFace++;
    }
    if (_isStore()) {
      countFace++;
    }
    return countFace;
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) => DefaultTabController(
          length: _countFace(),
          child: Scaffold(
            body: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (context, isBool) => [
                  const SliverToBoxAdapter(
                      child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: HeaderAppBar(isMenu: true, title: 'Подписки'),
                      ),
                    ],
                  )),
                  SliverPersistentHeader(
                      delegate: TabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: Theme.of(context).colorScheme.primary,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      unselectedLabelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      tabs: [
                        if (_isExecutor()) const Tab(text: 'Как исполнителя'),
                        if (_isStore()) const Tab(text: 'Как магазина'),
                      ],
                    ),
                  ))
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    if (_isExecutor())
                      CupertinoScrollbar(
                        controller: _scrollControllerExecutor,
                        child: SingleChildScrollView(
                          controller: _scrollControllerExecutor,
                          child: Container(
                            constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                BlocBuilder<DictionaryCubit, DictionaryState>(
                              builder: (context, state) => Column(
                                  children: state.subscribesExecutor
                                      .map((e) => SubscribeCard(
                                            subscribe: e,
                                          ))
                                      .toList()),
                            ),
                          ),
                        ),
                      ),
                    if (_isStore())
                      CupertinoScrollbar(
                        controller: _scrollControllerStore,
                        child: SingleChildScrollView(
                          controller: _scrollControllerStore,
                          child: Container(
                            constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                BlocBuilder<DictionaryCubit, DictionaryState>(
                              builder: (context, state) => Column(
                                  children: state.subscribesStore
                                      .map((e) => SubscribeCard(
                                            subscribe: e,
                                          ))
                                      .toList()),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  TabBarDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(child: tabBar);

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
