enum IndexPeriod {
  last3day,
  last7day,
  last30day;

  @override
  String toString() {
    switch (this) {
      case IndexPeriod.last3day:
        return '3 days';
      case IndexPeriod.last7day:
        return 'week';
      case IndexPeriod.last30day:
        return 'month';
    }
  }
}
