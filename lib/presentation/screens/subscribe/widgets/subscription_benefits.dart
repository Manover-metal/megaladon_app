import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

/// Что даёт подписка: заголовок и список того, что без неё закрыто.
///
/// Здесь только то, что реально проверяется в коде, без обещаний:
/// исполнителю — отклик на заказ и чат с заказчиком
/// (`DetailsOrderScreen`, `respond_requires_subscription`), звонок и чат по
/// объявлению и в профиле пользователя (`contact_requires_subscription`),
/// объявления типа «услуга» (`AdvertService::checkServiceAuthor`);
/// магазину — показ в каталоге металлопроката (`StoreRepo::applyFilter`)
/// и те же объявления об услугах.
class SubscriptionBenefits extends StatelessWidget {
  const SubscriptionBenefits({required this.type, super.key});

  final SubscribeType type;

  List<_Benefit> _benefits(AppLocalizations l10n) =>
      type == SubscribeType.executor
          ? [
              _Benefit(
                icon: Icons.assignment_turned_in_rounded,
                title: l10n.subscriptionExecutorBenefit1Title,
                text: l10n.subscriptionExecutorBenefit1Text,
              ),
              _Benefit(
                icon: Icons.phone_in_talk_rounded,
                title: l10n.subscriptionExecutorBenefit2Title,
                text: l10n.subscriptionExecutorBenefit2Text,
              ),
              _Benefit(
                icon: Icons.campaign_rounded,
                title: l10n.subscriptionExecutorBenefit3Title,
                text: l10n.subscriptionExecutorBenefit3Text,
              ),
            ]
          // У магазина подписка закрывает ровно два пункта. Третьего здесь
          // больше нет: «клиенты пишут сами, никакой комиссии за сделку» —
          // это было обещание, а не проверка в коде.
          : [
              _Benefit(
                icon: Icons.storefront_rounded,
                title: l10n.subscriptionStoreBenefit1Title,
                text: l10n.subscriptionStoreBenefit1Text,
              ),
              _Benefit(
                icon: Icons.campaign_rounded,
                title: l10n.subscriptionStoreBenefit2Title,
                text: l10n.subscriptionStoreBenefit2Text,
              ),
            ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type == SubscribeType.executor
              ? l10n.subscriptionExecutorBenefitsTitle
              : l10n.subscriptionStoreBenefitsTitle,
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 16),
        for (final benefit in _benefits(l10n))
          _BenefitTile(benefit: benefit),
      ],
    );
  }
}

class _Benefit {
  _Benefit({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;
}

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({required this.benefit});

  final _Benefit benefit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
            child: Icon(benefit.icon, color: primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  benefit.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.35,
                    color: theme.hintColor,
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
