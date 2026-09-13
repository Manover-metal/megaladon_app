import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/constants/legal_urls.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/locale/locale_cubit.dart';
import 'package:megaladon/logic/theme/theme_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/screens/settings/push_notification_tile.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';
import 'package:megaladon/presentation/widgets/settings/settings_option_sheet.dart';
import 'package:megaladon/presentation/widgets/settings/settings_row.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

const _localeNames = {
  'en': 'English',
  'ru': 'Русский',
  'kk': 'Қазақша',
};

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const double _sectionGap = 18;

  void _toAbout(BuildContext context) {
    context.router.navigate(const InitialRouter(children: [
      ProfileRouter(children: [AboutRoute()])
    ]));
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);

    // Раньше при неудаче метод просто выходил: пользователь жал «Политика
    // конфиденциальности», и не происходило ровным счётом ничего.
    final opened = await canLaunchUrl(uri) &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (opened || !context.mounted) return;

    CustomSnackBar.error(Text(AppLocalizations.of(context)!.linkOpenError))
        .view(context);
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

  String _localeName(Locale locale) =>
      _localeNames[locale.languageCode] ?? locale.languageCode;

  Future<void> _pickLocale(BuildContext context, Locale current) async {
    final picked = await SettingsOptionSheet.show<Locale>(
      context,
      title: AppLocalizations.of(context)!.language,
      options: AppLocalizations.supportedLocales,
      current: current,
      labelOf: _localeName,
    );

    if (picked == null || !context.mounted) return;
    context.read<LocaleCubit>().change(picked);
  }

  Future<void> _pickTheme(BuildContext context, ThemeMode current) async {
    final l10n = AppLocalizations.of(context)!;
    final picked = await SettingsOptionSheet.show<ThemeMode>(
      context,
      title: l10n.theme,
      options: ThemeMode.values,
      current: current,
      labelOf: (mode) => _themeName(mode, l10n),
    );

    if (picked == null || !context.mounted) return;
    context.read<ThemeCubit>().change(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.watch<LocaleCubit>().state;
    final currentTheme = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar:
          HeaderAppBar(isMenu: true, title: l10n.settings, compactTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentSection(
              title: l10n.settingsGroupAppearance,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SettingsRow(
                    icon: Icons.language_outlined,
                    title: l10n.language,
                    value: _localeName(currentLocale),
                    trailing: const SettingsChevron(),
                    onTap: () => _pickLocale(context, currentLocale),
                  ),
                  const SettingsRowDivider(),
                  SettingsRow(
                    icon: Icons.dark_mode_outlined,
                    title: l10n.theme,
                    value: _themeName(currentTheme, l10n),
                    trailing: const SettingsChevron(),
                    onTap: () => _pickTheme(context, currentTheme),
                  ),
                ],
              ),
            ),
            const SizedBox(height: _sectionGap),
            ContentSection(
              title: l10n.settingsGroupNotifications,
              padding: EdgeInsets.zero,
              child: const PushNotificationTile(),
            ),
            const SizedBox(height: _sectionGap),
            ContentSection(
              title: l10n.settingsGroupApp,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SettingsRow(
                    icon: Icons.info_outline,
                    title: l10n.about_the_application,
                    trailing: const SettingsChevron(),
                    onTap: () => _toAbout(context),
                  ),
                  const SettingsRowDivider(),
                  SettingsRow(
                    icon: Icons.description_outlined,
                    title: l10n.user_agreement,
                    trailing: const SettingsChevron(external: true),
                    onTap: () => _openUrl(context, userAgreementUrl),
                  ),
                  const SettingsRowDivider(),
                  SettingsRow(
                    icon: Icons.shield_outlined,
                    title: l10n.privacy_policy,
                    trailing: const SettingsChevron(external: true),
                    onTap: () => _openUrl(context, privacyPolicyUrl),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
