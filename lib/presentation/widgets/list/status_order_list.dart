import 'package:flutter/cupertino.dart';
import 'package:megaladon/presentation/widgets/card/status_order_card.dart';

class StatusList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 20),
          ...List.generate(20, (index) {
            return Row(
              children: [
                StatusOrderCard(),
                SizedBox(width: 10,),

              ],
            );
          })
        ]
      ),
    );
  }

}