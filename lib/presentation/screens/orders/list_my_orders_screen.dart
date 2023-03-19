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

class _ListMyOrdersScreenState extends State<ListMyOrdersScreen> {
   late ScrollController _scrollController;
   _listenerScroll() {
    if (_scrollController.position.maxScrollExtent < _scrollController.position.pixels) {
      final cubit = context.read<OrderScreenMyCubit>();
      if(cubit.state.status != OrderScreenMyStatus.loading) {
        OrderIndexRequestParams params = cubit.state.params;
        cubit.fetch(params: params.copyWith(startRow: params.startRow + params.rowsPerPage));
      }
    }
  }


  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_listenerScroll);
    _onRefresh();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenerScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    context.read<OrderScreenMyCubit>().fetch();
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
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isBool) {
            return [
              SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: HeaderAppBar(isMenu: true, title: 'Мои заказы'),
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
            ];
          },
          body: RefreshIndicator(
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
                  child: Column(
                    children: [
                      BlocBuilder<OrderScreenMyCubit, OrderScreenMyState>(
                        builder: (context, state) {

                          return Column(
                            children: [
                              ...state.orders.map((order) {
                                return OrderCard(order: order);
                              }).toList(),
                              if(state.status == OrderScreenMyStatus.loading) const Loader(padding: 10)
                              else if(state.status == OrderScreenMyStatus.error)  ErrorMessage(error: state.error!)
                              else if(state.stock) const StockMessage(name: 'Заказы')
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}