import 'package:flutter/material.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';

/// Легенда навигации: что за раздел скрывается за каждой вкладкой и за
/// кнопкой «+». Раньше всё это лежало одним `Text` с семью абзацами через
/// `\n` — читать приходилось подряд, чтобы найти один нужный пункт.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  /// Заголовки берутся из тех же ключей, что подписаны на вкладках
  /// (`SplashScreen`), а не дублируются отдельным текстом. Прежний `aboutText`
  /// успел разойтись с интерфейсом: он обещал «Металлопрокат» и «Торговую
  /// площадку», когда на вкладках уже было написано «Прокат» и «Объявления».
  List<_Section> _sections(AppLocalizations l10n) => [
        _Section(
          icon: IconPack.basket,
          title: l10n.tabOrders,
          text: l10n.aboutOrdersText,
        ),
        _Section(
          icon: IconPack.market,
          title: l10n.tabStores,
          text: l10n.aboutStoresText,
        ),
        _Section(
          icon: Icons.account_balance_wallet_outlined,
          title: l10n.tabAds,
          text: l10n.aboutAdsText,
        ),
        _Section(
          icon: IconPack.profile,
          title: l10n.tabProfile,
          text: l10n.aboutProfileText,
        ),
        _Section(
          icon: Icons.add,
          title: l10n.aboutCreateTitle,
          text: l10n.aboutCreateText,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sections = _sections(l10n);

    return Scaffold(
      appBar: HeaderAppBar(isBack: true, title: l10n.about_the_application),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final section in sections)
                _SectionTile(
                  section: section,
                  // Последнему отступ снизу не нужен: его добавляет padding
                  // самой карточки, иначе низ выглядит провисшим.
                  isLast: section == sections.last,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section {
  const _Section({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;
}

/// Тот же силуэт, что у пункта списка в `SubscriptionBenefits`: круг с
/// иконкой в 14% основного цвета, заголовок и пояснение справа.
class _SectionTile extends StatelessWidget {
  const _SectionTile({required this.section, required this.isLast});

  final _Section section;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: 0.14),
            ),
            child: Icon(section.icon, color: primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  section.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.4,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
