import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Text('Продаю металический лист 500*1500очень большой заголовок задания')
            )
          ],
        ),
      ),
    );
  }

}