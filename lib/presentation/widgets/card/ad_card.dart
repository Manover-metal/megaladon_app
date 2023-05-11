import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/core/themes/dark.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/presentation/routing/router.dart';

class AdCard extends StatelessWidget {

  final AdvertModel advert;

  const AdCard({super.key, required this.advert});

  _onTap(BuildContext context) => () {
    context.router.push(DetailsAdRoute(id: advert.id));
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: _onTap(context),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if(advert.media.isNotEmpty) ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height / 4,
                      maxHeight: MediaQuery.of(context).size.height / 3
                  ),
                  color: Theme.of(context).colorScheme.secondary,
                  child: CachedNetworkImage(
                    imageUrl: advert.media[0].url,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Icon(Icons.image_outlined, size: MediaQuery.of(context).size.width / 10),
                    errorWidget:  (context, url, error) => Icon(Icons.error_outline, size: MediaQuery.of(context).size.width / 10),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(advert.title),
                    Text(advert.description, maxLines: 3,),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Text('${advert.price} ₸',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorSchemeApp.success.color,
                  fontWeight: FontWeight.w600
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }
}