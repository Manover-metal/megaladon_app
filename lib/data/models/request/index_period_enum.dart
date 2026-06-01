import 'package:megaladon/generated/l10n/app_localizations.dart';

enum IndexPeriod {
  last3day,
  last7day,
  last30day;

  String localize(AppLocalizations l10n) {
    switch (this) {
      case IndexPeriod.last3day:
        return l10n.last_3_days;
      case IndexPeriod.last7day:
        return l10n.last_week;
      case IndexPeriod.last30day:
        return l10n.last_month;
    }
  }
}
