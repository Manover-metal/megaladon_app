enum OrderIndexSort {
  id,
  created_at,
  status,
  category_id;

  @override
  String toString() {
    switch (this) {
      case OrderIndexSort.id:
        return 'By creation';
      case OrderIndexSort.created_at:
        return 'By date';
      case OrderIndexSort.status:
        return 'By status';
      case OrderIndexSort.category_id:
        return 'By category';
    }
  }
}
