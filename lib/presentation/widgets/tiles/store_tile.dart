import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/store_model.dart';

class StoreTile extends StatelessWidget {

  final StoreModel store;

  const StoreTile({super.key, required this.store});

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
              child: (store.photo != null) ? Image.network(
                store.photo!,
                fit: BoxFit.cover,
              ): null,
            ),
            SizedBox(width: 10,),
            Expanded(
              flex: 8,
              child: Text('${store.type?.name ?? ''} "${store.name}"')
            )
          ],
        ),
      ),
    );
  }

}