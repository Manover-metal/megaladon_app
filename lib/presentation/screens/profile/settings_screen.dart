import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/locale/locale_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

const _localeNames = {
  'en': 'English',
  'ru': 'Русский',
  'kk': 'Қазақша',
};

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _toAbout(BuildContext context) {
    context.router.navigate(const InitialRouter(children: [
      ProfileRouter(children: [AboutRoute()])
    ]));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.read<LocaleCubit>().state;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                HeaderAppBar(isMenu: true, title: l10n.settings),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(l10n.language)),
                    Expanded(
                      child: DropdownButton<Locale>(
                        isExpanded: true,
                        value: currentLocale,
                        items: AppLocalizations.supportedLocales
                            .map((locale) => DropdownMenuItem(
                                  value: locale,
                                  child: Text(
                                    _localeNames[locale.languageCode] ??
                                        locale.languageCode,
                                  ),
                                ))
                            .toList(),
                        onChanged: (locale) {
                          if (locale != null) {
                            context.read<LocaleCubit>().change(locale);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                OutlinedButtonApp(
                  text: l10n.about_the_application,
                  onPressed: () => _toAbout(context),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) => Switch(
        // This bool value toggles the switch.
        value: light,
        activeThumbColor: Colors.green,
        onChanged: (value) {
          // This is called when the user toggles the switch.
          setState(() {
            light = value;
          });
        },
      );
}
