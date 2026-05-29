import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

class StockMessage extends StatelessWidget {
  const StockMessage({required this.name, super.key});
  final String name;

  @override
  Widget build(BuildContext context) => Container(
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
                TextSpan(
                    text: AppLocalizations.of(context)!.for_this_request_ended),
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
      ));
}
