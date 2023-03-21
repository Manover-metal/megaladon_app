import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/generated/locale_keys.g.dart';

class StockMessage extends StatelessWidget {
  final String name;

  const StockMessage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.secondary,
            size: 35,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: name),
                TextSpan(text: LocaleKeys.for_this_request_ended.tr()),
              ],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )
    );
  }

}
