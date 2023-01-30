import 'package:flutter/cupertino.dart';
import 'package:megaladon/presentation/widgets/card/status_order_card.dart';

class StatusList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          StatusOrderCard(),
          StatusOrderCard(),
          StatusOrderCard(),
          StatusOrderCard(),
          StatusOrderCard(),
        ],
      ),
    );
  }

}