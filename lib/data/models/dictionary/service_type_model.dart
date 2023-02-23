class ServiceTypeModel {
  final int id;
  final String name;

  ServiceTypeModel({required this.id, required this.name});

  static ServiceTypeModel fromJson(data) {
    return ServiceTypeModel(
      id: data['id'],
      name: data['name'],
    );
  }

  static List<ServiceTypeModel> listFromJson(data) {
    return data.map<ServiceTypeModel>((city) => ServiceTypeModel.fromJson(city)).toList();
  }
}