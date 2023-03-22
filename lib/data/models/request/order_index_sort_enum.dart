
import 'package:easy_localization/easy_localization.dart';

enum OrderIndexSort {
  id,
  createdAt,
  status,
  categoryId;

  @override
  String toString() {
    switch(this) {
      case OrderIndexSort.id: return 'By_creation'.tr();
      case OrderIndexSort.createdAt: return 'By_date'.tr();
      case OrderIndexSort.status: return 'By_status'.tr();
      case OrderIndexSort.categoryId: return 'By_category'.tr();
    }
  }
}