
enum OrderIndexSort {
  id,
  created_at,
  status,
  category_id;

  @override
  String toString() {
    switch(this) {
      case OrderIndexSort.id: return 'По созданию';
      case OrderIndexSort.created_at: return 'По дате';
      case OrderIndexSort.status: return 'По статусу';
      case OrderIndexSort.category_id: return 'По категории';
    }
  }
}