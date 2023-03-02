class ServiceTypeModel {
  final int id;
  final String name;

  ServiceTypeModel({required this.id, required this.name});

  static ServiceTypeModel fromJson(data) {
    try {
      return ServiceTypeModel(
        id: data['id'],
        name: data['name'],
      );
    } catch(e) {
      return ServiceTypeModel.nothing;
    }
  }

  static List<ServiceTypeModel> listFromJson(data) {
    return data.map<ServiceTypeModel>((city) => ServiceTypeModel.fromJson(city)).toList();
  }

  static ServiceTypeModel get nothing => ServiceTypeModel(id: -1, name: '');

}