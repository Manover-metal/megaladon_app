import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_order_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/sort/sort_order_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/order_card.dart';
import 'package:megaladon/presentation/widgets/error/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/generated/locale_keys.g.dart';

class ListOrdersScreen extends StatefulWidget {
  @override
  State<ListOrdersScreen> createState() => _ListOrdersScreenState();
}

class _ListOrdersScreenState extends State<ListOrdersScreen> {

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

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
    if(result != null) {
      context.read<OrderScreenMainCubit>().fetch();
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            HeaderAppBar(isMenu: true, ),
                            TitleApp(LocaleKeys.Orders.tr()),
                            SizedBox(height: 20,),
                            
                            
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Icon(Icons.sort, size: 30),
                              onTap: _showSort,
                            ),
                            SizedBox(width: 10,),
                            InkWell(
                              child: Icon(Icons.filter_alt, size: 30),
                              onTap: _showFilter,
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
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    BlocBuilder<OrderScreenMainCubit, OrderScreenMainState>(
                      builder: (context, state) {
                        if(state is OrderScreenMainSuccess) {
                          return Column(
                            children: state.orders.map((order) {
                              return OrderCard(order: order);
                            }).toList(),
                          );
                        }
                        else if(state is OrderScreenMainLoader) {
                          return const Loader(padding: 10,);
                        } else if(state is OrderScreenMainError) {
                          return ErrorMessage(error: state.error);
                        }
                        return Container();
                      },
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
}