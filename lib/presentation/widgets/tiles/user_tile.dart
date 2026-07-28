import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

class UserTile extends StatelessWidget {
  const UserTile({required this.user, this.onTap, super.key});
  final UserModel user;

  /// Когда не передан, тайл ведёт себя как раньше — просто блок информации.
  /// Это важно: виджет используется и там, где перехода быть не должно.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.height / 10,
                  height: MediaQuery.of(context).size.height / 10,
                  color: Theme.of(context).colorScheme.secondary,
                  child: CachedNetworkImage(
                    imageUrl: user.photo ?? '',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Icon(Icons.person,
                            size: MediaQuery.of(context).size.width / 10),
                    errorWidget: (context, url, error) => Icon(Icons.person,
                        size: MediaQuery.of(context).size.width / 10),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(text: AppLocalizations.of(context)!.customer2),
                      TextSpan(
                          text: user.name,
                          style: user.isDeleted
                              ? TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontStyle: FontStyle.italic)
                              : null)
                    ])),
                    const SizedBox(
                      height: 5,
                    ),
                    // У удалённого аккаунта счётчика заказов нет — иначе в строке
                    // оказалось бы «null».
                    if (user.countOrders != null)
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text:
                                AppLocalizations.of(context)!.posted_projects),
                        TextSpan(text: user.countOrders.toString())
                      ]))
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
