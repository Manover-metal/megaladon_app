class CityModel {
  CityModel({required this.id, required this.name});
  final int id;
  final String name;

  static CityModel fromJson(data) {
    try {
      return CityModel(
        id: data['id'] as int,
        name: data['title'] as String,
      );
    } catch (e) {
      return CityModel.nothing;
    }
  }

  static List<CityModel> listFromJson(data) => (data as List)
      .map<CityModel>(
          (item) => CityModel.fromJson(item as Map<String, dynamic>))
      .toList();

  static CityModel get nothing => CityModel(id: -1, name: '');
}
