import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';

class AuthMessage extends StatelessWidget {
  const AuthMessage({super.key, this.continueText});
  final String? continueText;

  Null Function() _login(BuildContext context) => () {
        context.router.navigate(const LoginRoute());
      };

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(AppLocalizations.of(context)!.authorization,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white)),
          Text(
            '${AppLocalizations.of(context)!.you_need_to_log_into_the_application}${continueText ?? ''}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButtonApp(
            onPressed: _login(context),
            text: AppLocalizations.of(context)!.continueAction,
          )
        ],
      );
}
