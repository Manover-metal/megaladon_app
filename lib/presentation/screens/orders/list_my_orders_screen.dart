import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/repositories/order_repository.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/card/order_card.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_app.dart';
import 'package:megaladon/presentation/widgets/list/status_order_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ListMyOrdersScreen extends StatefulWidget {
  @override
  State<ListMyOrdersScreen> createState() => _ListMyOrdersScreenState();
}

class _ListMyOrdersScreenState extends State<ListMyOrdersScreen> {
  
  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  Future _onRefresh() async {
    context.read<OrderScreenMyCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        HeaderAppBar(isMenu: true, ),
                        TitleApp('Мои заказы'),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                  StatusList(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<OrderScreenMyCubit, OrderScreenMyState>(
                      builder: (context, state) {
                        if(state is OrderScreenMySuccess) {
                          return Column(
                            children: state.orders.map((advert) {
                              return OrderCard();
                            }).toList(),
                          );
                        }
                        else if(state is OrderScreenMyLoader) {
                          return const Loader();
                        }
                        return Container();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}