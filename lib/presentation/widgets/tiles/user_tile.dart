import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;

  const UserTile({super.key, required this.user});


  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.height /10,
              height: MediaQuery.of(context).size.height /10,
              color: Theme.of(context).colorScheme.secondary,
              child: CachedNetworkImage(
                imageUrl: user.photo ?? '',
                progressIndicatorBuilder: (context, url, downloadProgress) => Icon(Icons.person, size: MediaQuery.of(context).size.width / 10),
                errorWidget:  (context, url, error) => Icon(Icons.person, size: MediaQuery.of(context).size.width / 10),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Заказчик: '),
                      TextSpan(text: user.name)
                    ]
                  )
                ),
                const SizedBox(height: 5,),
                Text.rich(
                    TextSpan(
                        children: [
                          const TextSpan(text: 'Размещено проектов: '),
                          TextSpan(text: user.countOrders.toString())
                        ]
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}