import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/themes/dark.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/tiles/ad_tile.dart';

class AdCard extends StatelessWidget {

  final AdvertModel advert;

  const AdCard({super.key, required this.advert});

  _onTap(BuildContext context) => () {
    context.router.push(DetailsAdRoute(id: advert.id));
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: _onTap(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdTile(advert: advert,),
              SizedBox(height: 5,),

              Text(advert.description),
              SizedBox(height: 10,),
              Text('Цена: ${advert.price} ₸',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorSchemeApp.success.color,
                  fontWeight: FontWeight.w600
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }
}