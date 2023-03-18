import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/advert_model.dart';

class AdTile extends StatelessWidget {

  final AdvertModel advert;

  const AdTile({super.key, required this.advert});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(advert.title)
    );
  }

}