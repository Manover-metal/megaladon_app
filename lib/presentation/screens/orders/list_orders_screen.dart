import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_order_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/sort/sort_order_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/order_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/message/stock_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class ListOrdersScreen extends StatefulWidget {
  const ListOrdersScreen({super.key});

  @override
  State<ListOrdersScreen> createState() => _ListOrdersScreenState();
}

class _ListOrdersScreenState extends State<ListOrdersScreen> {
  late ScrollController _scrollController;

  Future _onRefresh() async {
    await context.read<OrderScreenMainCubit>().refresh();
  }

  Future<void> _showFilter() async {
    var result = await const FilterOrderBottomSheet().show(context);
    if (result != null && result) {
      context.read<OrderScreenMainCubit>().fetch();
    }
  }

  Future<void> _showSort() async {
    var result = await const SortOrderBottomSheet().show(context);
    if (result != null && result) {
      context.read<OrderScreenMainCubit>().fetch();
    }
  }

  void _listenerScroll() {
    if (_scrollController.position.maxScrollExtent <
        _scrollController.position.pixels) {
      final cubit = context.read<OrderScreenMainCubit>();
      if (cubit.state.status != OrderScreenMainStatus.loading) {
        var params = cubit.state.params;
        cubit.fetch(
            params: params.copyWith(
                startRow: params.startRow + params.rowsPerPage));
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
  Widget build(BuildContext context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: BlocBuilder<OrderScreenMainCubit, OrderScreenMainState>(
            builder: (context, state) => HeaderAppBar(
              isMenu: true,
              title: AppLocalizations.of(context)!.orders,
              onTrailing: _onRefresh,
              trailing: state.status != OrderScreenMainStatus.loading
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: _showSort,
                        child: const Icon(Icons.sort, size: 30),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: _showFilter,
                        child: const Icon(Icons.filter_alt, size: 30),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ],
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: CupertinoScrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      BlocBuilder<OrderScreenMainCubit, OrderScreenMainState>(
                        builder: (context, state) => Column(
                          children: [
                            ...state.orders
                                .map((order) => OrderCard(order: order))
                                .toList(),
                            if (state.status == OrderScreenMainStatus.loading)
                              const Loader(padding: 10)
                            else if (state.status ==
                                OrderScreenMainStatus.error)
                              ErrorMessage(error: state.error!)
                            else if (state.stock)
                              StockMessage(
                                  name: AppLocalizations.of(context)!.orders)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
