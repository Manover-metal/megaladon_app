class CityModel {
  CityModel({required this.id, required this.name});
  final int id;
  final String name;

  static CityModel fromJson(Map<String, dynamic> data) {
    late final String name;

    if (data['title'] is String) {
      name = data['title'] as String;
    } else if (data['name'] is String) {
      name = data['name'] as String;
    }

    return CityModel(
      id: data['id'] as int,
      name: name,
    );
  }

  static List<CityModel> listFromJson(List<dynamic> data) => data
      .map<CityModel>(
          (item) => CityModel.fromJson(item as Map<String, dynamic>))
      .toList();

  Map<String, dynamic> toJson() => {'id': id, 'title': name};
}
