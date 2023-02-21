import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/advert_model.dart';

class AdTile extends StatelessWidget {

  final AdvertModel advert;

  const AdTile({super.key, required this.advert});

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
                child: Text(advert.title)
            )
          ],
        ),
      ),
    );
  }

}