import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/advert_model.dart';

class AdTile extends StatelessWidget {
  const AdTile({required this.advert, super.key});
  final AdvertModel advert;

  @override
  Widget build(BuildContext context) => Text(advert.title);
}
