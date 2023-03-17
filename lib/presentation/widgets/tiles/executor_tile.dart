import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/executor_model.dart';

class ExecutorTile extends StatelessWidget {

  final ExecutorModel executor;

  const ExecutorTile({super.key, required this.executor});

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
                            TextSpan(text: 'Иполнитель: '),
                            TextSpan(text: executor.name)
                          ]
                      )
                  ),
                  SizedBox(height: 5,),
                  if(executor.countOrders != null) Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(text: 'Размещено проектов: '),
                            TextSpan(text: executor.countOrders.toString())
                          ]
                      )
                  ),
                  SizedBox(height: 5,),
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(text: 'Рейтинг: '),
                            TextSpan(text: executor.rating ?? '0')
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