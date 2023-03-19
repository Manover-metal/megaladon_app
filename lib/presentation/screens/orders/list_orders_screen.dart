import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/params/index/order_index_request_params.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_order_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/sort/sort_order_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/order_card.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/stock_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/generated/locale_keys.g.dart';

class ListOrdersScreen extends StatefulWidget {
  const ListOrdersScreen({super.key});

  @override
  State<ListOrdersScreen> createState() => _ListOrdersScreenState();
}

class _ListOrdersScreenState extends State<ListOrdersScreen> {
  late ScrollController _scrollController;


  Future _onRefresh() async {
    await context.read<OrderScreenMainCubit>().fetch();
  }

  _showFilter() async {
    bool? result = await showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => FilterOrderBottomSheet()
    );
    if(result != null) {
      context.read<OrderScreenMainCubit>().fetch();
    }
  }

  _showSort() async {
    bool? result = await showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => SortOrderBottomSheet()
    );
    if(result != null && result) {
      context.read<OrderScreenMainCubit>().fetch();
    }
  }

  _listenerScroll() {
    if (_scrollController.position.maxScrollExtent < _scrollController.position.pixels) {
      final cubit = context.read<OrderScreenMainCubit>();
      if(cubit.state.status != OrderScreenMainStatus.loading) {
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: HeaderAppBar(isMenu: true, title: LocaleKeys.Orders.tr()),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: _showSort,
                              child: const Icon(Icons.sort, size: 30),
                            ),
                            const SizedBox(width: 10,),
                            InkWell(
                              onTap: _showFilter,
                              child: const Icon(Icons.filter_alt, size: 30),
                            ),
                          ],
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
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      BlocBuilder<OrderScreenMainCubit, OrderScreenMainState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              ...state.orders.map((order) {
                                return OrderCard(order: order);
                              }).toList(),
                              if(state.status == OrderScreenMainStatus.loading) const Loader(padding: 10)
                              else if(state.status == OrderScreenMainStatus.error) ErrorMessage(error: state.error!)
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