import 'package:cached_network_image/cached_network_image.dart';
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.height /10,
                height: MediaQuery.of(context).size.height /10,
                color: Theme.of(context).colorScheme.secondary,
                child: CachedNetworkImage(
                  imageUrl: executor.photo ?? '',
                  progressIndicatorBuilder: (context, url, downloadProgress) => Icon(Icons.person, size: MediaQuery.of(context).size.width / 10),
                  errorWidget:  (context, url, error) => Icon(Icons.person, size: MediaQuery.of(context).size.width / 10),
                  fit: BoxFit.cover,
                ),
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