import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/routing/router.dart';

class OrderCard extends StatelessWidget {

  _onTap(BuildContext context) => () {
    context.router.push(const DetailsOrderRoute());
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap(context),
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text('Изготовить скользящие опоры DN-5000 под стойки опорных башней очень большой за...'),
                  Text('Но убеждённость некоторых оппонентов позволяет оценить значение приоритизации разума над эмоциями. Не следует, однако, забывать, что.'),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 10,),
                      Text('Предложений: 10')
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('25.01.2005')
                  )
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('В работе')
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}