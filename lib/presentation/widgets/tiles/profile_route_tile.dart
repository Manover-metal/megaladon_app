import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class ProfileRouteTile extends StatelessWidget {
  const ProfileRouteTile({required this.text, required this.page, super.key});
  final String text;
  final PageRouteInfo page;

  Null Function() _onTap(BuildContext context) => () {
        context.router.navigate(page);
      };

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _onTap(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child:
                      Text(text, style: Theme.of(context).textTheme.bodyMedium),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      );
}
