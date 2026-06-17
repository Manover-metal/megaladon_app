import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/locale/locale_cubit.dart';
import 'package:megaladon/logic/theme/theme_cubit.dart';
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

  String _themeName(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.dark:
        return l10n.theme_dark;
      case ThemeMode.light:
        return l10n.theme_light;
      case ThemeMode.system:
        return l10n.theme_system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.watch<LocaleCubit>().state;
    final currentTheme = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar: HeaderAppBar(isMenu: true, title: l10n.settings),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(l10n.theme)),
                  Expanded(
                    child: DropdownButton<ThemeMode>(
                      isExpanded: true,
                      value: currentTheme,
                      items: ThemeMode.values
                          .map((mode) => DropdownMenuItem(
                                value: mode,
                                child: Text(_themeName(mode, l10n)),
                              ))
                          .toList(),
                      onChanged: (mode) {
                        if (mode != null) {
                          context.read<ThemeCubit>().change(mode);
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
    );
  }
}
