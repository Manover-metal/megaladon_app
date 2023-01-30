import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/card/order_card.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_app.dart';
import 'package:megaladon/presentation/widgets/list/status_order_list.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class ListOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    HeaderAppBar(isMenu: true, ),
                    Text('Заказы')
                  ],
                ),
              ),
              StatusList(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    children: List.generate(5, (index) {
                      return OrderCard();
                    }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}