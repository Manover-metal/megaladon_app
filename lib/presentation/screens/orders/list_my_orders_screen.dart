import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/params/index/order_index_request_params.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_order_my_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/order_card.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/stock_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class ListMyOrdersScreen extends StatefulWidget {
  const ListMyOrdersScreen({super.key});

  @override
  State<ListMyOrdersScreen> createState() => _ListMyOrdersScreenState();
}

class _ListMyOrdersScreenState extends State<ListMyOrdersScreen> with SingleTickerProviderStateMixin {
   late ScrollController _scrollController;
   late ScrollController _scrollControllerResponded;
   late TabController _tabController;

   _listenerScrollMy() {
    if (_scrollController.position.maxScrollExtent < _scrollController.position.pixels) {
      final cubit = context.read<OrderScreenMyCubit>();
      if(cubit.state.status != OrderScreenMyStatus.loading) {
        OrderIndexRequestParams params = cubit.state.params;
        cubit.fetch(params: params.copyWith(startRow: params.startRow + params.rowsPerPage));
      }
    }
  }

   _listenerScrollResponded() {
     if (_scrollControllerResponded.position.maxScrollExtent < _scrollControllerResponded.position.pixels) {
       final cubit = context.read<OrderScreenMyCubit>();
       if(cubit.state.status != OrderScreenMyStatus.loading) {
         OrderIndexRequestParams params = cubit.state.params;
         cubit.fetch(params: params.copyWith(startRow: params.startRow + params.rowsPerPage));
       }
     }
   }


  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_listenerScrollMy);
    _scrollControllerResponded = ScrollController()..addListener(_listenerScrollResponded);

    _tabController = TabController(length: 2, vsync: this);
    _onRefresh();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenerScrollMy);
    _scrollController.dispose();
    _scrollControllerResponded.removeListener(_listenerScrollResponded);
    _scrollControllerResponded.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    return context.read<OrderScreenMyCubit>().fetch();
  }

  _showFilter() async {
    bool? result = await showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => FilterMyOrderBottomSheet()
    );
    if(result != null) {
      context.read<OrderScreenMyCubit>().fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                          child: HeaderAppBar(isMenu: true, title: "My_orders".tr()),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: _showFilter,
                              child: const Icon(Icons.filter_alt,  size: 30),
                            ),
                          ),
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
                        Tab(text: "As_a_user".tr()),
                        Tab(text:"As_a_executor".tr()),
                      ],
                    ),
                  )
                )
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: CupertinoScrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocBuilder<OrderScreenMyCubit, OrderScreenMyState>(
                          builder: (context, state) {

                            return Column(
                              children: [
                                ...state.orders.map((order) {
                                  return OrderCard(order: order);
                                }).toList(),
                                if(state.status == OrderScreenMyStatus.loading) const Loader(padding: 10)
                                else if(state.status == OrderScreenMyStatus.error)  ErrorMessage(error: state.error!)
                                else if(state.stock)  StockMessage(name: "Orders".tr())
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: CupertinoScrollbar(
                    controller: _scrollControllerResponded,
                    child: SingleChildScrollView(
                      controller: _scrollControllerResponded,
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocBuilder<OrderScreenMyCubit, OrderScreenMyState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                ...state.ordersResponded.map((order) {
                                  return OrderCard(order: order);
                                }).toList(),
                                if(state.status == OrderScreenMyStatus.loading) const Loader(padding: 10)
                                else if(state.status == OrderScreenMyStatus.error)  ErrorMessage(error: state.error!)
                                else if(state.stockResponded)  StockMessage(name: "Orders".tr())
                              ],
                            );
                          },
                        ),
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
