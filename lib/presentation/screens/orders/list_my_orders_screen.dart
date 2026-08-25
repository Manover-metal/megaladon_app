import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/order_badges_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/orders/badges/order_badges_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/widgets/badge/unread_badge.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_order_my_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/order_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/message/stock_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class ListMyOrdersScreen extends StatefulWidget {
  const ListMyOrdersScreen({super.key});

  @override
  State<ListMyOrdersScreen> createState() => _ListMyOrdersScreenState();
}

class _ListMyOrdersScreenState extends State<ListMyOrdersScreen> {
  late ScrollController _scrollController;
  late ScrollController _scrollControllerResponded;

  void _listenerScrollMy() {
    if (_scrollController.position.maxScrollExtent <
        _scrollController.position.pixels) {
      final cubit = context.read<OrderScreenMyCubit>();
      if (cubit.state.status != OrderScreenMyStatus.loading) {
        var params = cubit.state.params;
        cubit.fetchMy(
            params: params.copyWith(
                startRow: params.startRow + params.rowsPerPage));
      }
    }
  }

  void _listenerScrollResponded() {
    if (_scrollControllerResponded.position.maxScrollExtent <
        _scrollControllerResponded.position.pixels) {
      final cubit = context.read<OrderScreenMyCubit>();
      if (cubit.state.status != OrderScreenMyStatus.loading) {
        var params = cubit.state.params;
        cubit.fetchResponded(
            params: params.copyWith(
                startRow: params.startRow + params.rowsPerPage));
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_listenerScrollMy);
    _scrollControllerResponded = ScrollController()
      ..addListener(_listenerScrollResponded);
    _onRefresh();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenerScrollMy);
    _scrollController.dispose();
    _scrollControllerResponded.removeListener(_listenerScrollResponded);
    _scrollControllerResponded.dispose();
    super.dispose();
  }

  // refresh() сбрасывает startRow и перезагружает оба списка (мои/отклики)
  // с первой страницы, сохраняя фильтры. Заодно перечитываем счётчики: на
  // вкладках они должны сходиться с тем, что показывают карточки.
  Future<void> _onRefresh() async {
    await context.read<OrderScreenMyCubit>().refresh();
    if (!mounted) return;
    await context.read<OrderBadgesCubit>().fetch();
  }

  Future<void> _showFilter() async {
    var result = await showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => const FilterMyOrderBottomSheet());
    if (result != null) {
      _onRefresh();
    }
  }

  bool _isExecutor() {
    final a = context.read<ProfileScreenCubit>().hasExecutor();
    print(a);
    return a;
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) =>
            BlocBuilder<OrderBadgesCubit, OrderBadgesState>(
                builder: (context, badgesState) =>
                    _buildTabs(context, badgesState.badges)),
      );

  Widget _buildTabs(BuildContext context, OrderBadges badges) =>
      DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: BlocBuilder<OrderScreenMyCubit, OrderScreenMyState>(
                builder: (context, state) => HeaderAppBar(
                  isMenu: true,
                  title: AppLocalizations.of(context)!.my_orders,
                  onTrailing: _onRefresh,
                  trailing: state.status != OrderScreenMyStatus.loading
                      ? const Icon(Icons.refresh, size: 30)
                      : const CupertinoActivityIndicator(),
                ),
              ),
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, isBool) => [
                SliverToBoxAdapter(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: _showFilter,
                          child: const Icon(Icons.filter_alt, size: 30),
                        ),
                      ),
                    ),
                  ],
                )),
                SliverPersistentHeader(
                    delegate: TabBarDelegate(
                  TabBar(
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
                      _BadgedTab(
                        text: AppLocalizations.of(context)!.as_a_user,
                        count: badges.my,
                      ),
                      _BadgedTab(
                        text: AppLocalizations.of(context)!.as_a_executor,
                        count: badges.responded,
                      ),
                    ],
                  ),
                ))
              ],
              body: TabBarView(
                children: [
                  RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: CupertinoScrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height + 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: BlocBuilder<OrderScreenMyCubit,
                              OrderScreenMyState>(
                            builder: (context, state) => Column(
                              children: [
                                ...state.orders
                                    .map((order) => OrderCard(order: order))
                                    .toList(),
                                if (state.status == OrderScreenMyStatus.loading)
                                  const Loader(padding: 10)
                                else if (state.status ==
                                    OrderScreenMyStatus.error)
                                  ErrorMessage(error: state.error!)
                                else if (state.stock)
                                  StockMessage(
                                      name:
                                          AppLocalizations.of(context)!.orders)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_isExecutor())
                    RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: CupertinoScrollbar(
                        controller: _scrollControllerResponded,
                        child: SingleChildScrollView(
                          controller: _scrollControllerResponded,
                          child: Container(
                            constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height + 200),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: BlocBuilder<OrderScreenMyCubit,
                                OrderScreenMyState>(
                              builder: (context, state) {
                                print(
                                    'responded ${state.stockResponded} ${state.ordersResponded} ${state.status}');
                                return Column(
                                  children: [
                                    ...state.ordersResponded
                                        .map((order) => OrderCard(order: order))
                                        .toList(),
                                    if (state.status ==
                                        OrderScreenMyStatus.loading)
                                      const Loader(padding: 10)
                                    else if (state.status ==
                                        OrderScreenMyStatus.error)
                                      ErrorMessage(error: state.error!)
                                    else if (state.stockResponded)
                                      StockMessage(
                                          name: AppLocalizations.of(context)!
                                              .orders)
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                        child: Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          AppLocalizations.of(context)!.registerAsExecutor),
                    )),
                ],
              ),
            ),
          ));
}

/// Заголовок вкладки со счётчиком изменившихся заказов.
class _BadgedTab extends StatelessWidget {
  const _BadgedTab({required this.text, required this.count});

  final String text;
  final int count;

  @override
  Widget build(BuildContext context) => Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(text, overflow: TextOverflow.ellipsis)),
            if (count > 0) ...[
              const SizedBox(width: 6),
              UnreadBadge(count: count),
            ],
          ],
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
