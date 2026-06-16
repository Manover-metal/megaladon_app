class CompanyTypeModel {
  CompanyTypeModel({required this.id, required this.name});
  final int id;
  final String name;

  static CompanyTypeModel fromJson(Map<String, dynamic> data) {
    late final String name;

    if (data['name'] is String) {
      name = data['name'] as String;
    } else if (data['title'] is String) {
      name = data['title'] as String;
    } else {
      name = '';
    }

    return CompanyTypeModel(
      id: data['id'] as int,
      name: name,
    );
  }

  static List<CompanyTypeModel> listFromJson(List<dynamic> data) => data
      .map<CompanyTypeModel>(
          (item) => CompanyTypeModel.fromJson(item as Map<String, dynamic>))
      .toList();

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
