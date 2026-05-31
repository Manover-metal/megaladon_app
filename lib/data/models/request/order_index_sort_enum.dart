import 'package:megaladon/generated/l10n/app_localizations.dart';

enum OrderIndexSort {
  id,
  created_at,
  status,
  category_id;

  String localize(AppLocalizations l10n) {
    switch (this) {
      case OrderIndexSort.id:
        return l10n.by_creation;
      case OrderIndexSort.created_at:
        return l10n.by_date;
      case OrderIndexSort.status:
        return l10n.by_status;
      case OrderIndexSort.category_id:
        return l10n.by_category;
      default:
        return l10n.by_creation;
    }
  }
}
