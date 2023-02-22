import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;

  const UserTile({super.key, required this.user});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntrinsicHeight(
        child: Row(
          children: [
            if(user.photo == null) Container(
              width: MediaQuery.of(context).size.height /10,
              height: MediaQuery.of(context).size.height /10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: Icon(Icons.person, size: MediaQuery.of(context).size.height /13,),
            )
            else Container(
              width: MediaQuery.of(context).size.height /10,
              height: MediaQuery.of(context).size.height /10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: Image.network(user.photo!, fit: BoxFit.cover,),
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
                        TextSpan(text: user.name)
                      ]
                    )
                  ),
                  SizedBox(height: 5,),
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(text: 'Размещено проектов: '),
                            TextSpan(text: user.countOrders.toString())
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