class ServiceTypeModel {
  ServiceTypeModel({required this.id, required this.name});
  final int id;
  final String name;

  static ServiceTypeModel fromJson(data) {
    try {
      return ServiceTypeModel(
        id: data['id'] as int,
        name: (data['name'] ?? data['title']) as String,
      );
    } catch (e) {
      return ServiceTypeModel.nothing;
    }
  }

  static List<ServiceTypeModel> listFromJson(List<dynamic> data) => data
      .map<ServiceTypeModel>(
          (item) => ServiceTypeModel.fromJson(item as Map<String, dynamic>))
      .toList();

  static ServiceTypeModel get nothing => ServiceTypeModel(id: -1, name: '');

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
