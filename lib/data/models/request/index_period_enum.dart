import 'package:easy_localization/easy_localization.dart';

enum IndexPeriod {
  last3day,
  last7day,
  last30day;

  @override
  String toString() {
    switch(this) {
      case IndexPeriod.last3day: return 'days_3'.tr();
      case IndexPeriod.last7day: return 'week'.tr();
      case IndexPeriod.last30day: return 'month'.tr();
    }
  }
}