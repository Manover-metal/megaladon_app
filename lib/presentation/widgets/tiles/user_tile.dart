import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.height /10,
              height: MediaQuery.of(context).size.height /10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Заказчик: '),
                        TextSpan(text: 'Steelmaster1978')
                      ]
                    )
                  ),
                  SizedBox(height: 5,),
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(text: 'Размещено проектов: '),
                            TextSpan(text: '125')
                          ]
                      )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}