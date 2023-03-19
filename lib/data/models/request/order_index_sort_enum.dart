
enum OrderIndexSort {
  id,
  createdAt,
  status,
  categoryId;

  @override
  String toString() {
    switch(this) {
      case OrderIndexSort.id: return 'По созданию';
      case OrderIndexSort.createdAt: return 'По дате';
      case OrderIndexSort.status: return 'По статусу';
      case OrderIndexSort.categoryId: return 'По категории';
    }
  }
}