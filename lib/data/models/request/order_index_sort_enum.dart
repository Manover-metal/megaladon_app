
import 'package:easy_localization/easy_localization.dart';

enum OrderIndexSort {
  id,
  created_at,
  status,
  category_id;

  @override
  String toString() {
    switch(this) {
      case OrderIndexSort.id: return 'By_creation'.tr();
      case OrderIndexSort.created_at: return 'By_date'.tr();
      case OrderIndexSort.status: return 'By_status'.tr();
      case OrderIndexSort.category_id: return 'By_category'.tr();
    }
  }
}