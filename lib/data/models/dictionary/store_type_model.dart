/// Тип магазина — склад, розница и т.п. Бэкенд отдаёт его и в списке, и в
/// детальном ответе (`StorePresenter::list`), но до сих пор поле терялось
/// при разборе, и отличить склад от прилавка в приложении было нельзя.
class StoreTypeModel {
  StoreTypeModel({required this.id, required this.name});
  final int id;
  final String name;

  static StoreTypeModel? fromJsonOrNull(Object? data) {
    if (data is! Map<String, dynamic>) return null;

    final id = data['id'];
    final name = data['name'] ?? data['title'];
    if (id is! int || name is! String) return null;

    return StoreTypeModel(id: id, name: name);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
