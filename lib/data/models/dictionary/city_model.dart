class CityModel {
  final int id;
  final String name;

  CityModel({required this.id, required this.name});

  static CityModel fromJson(data) {
    return CityModel(
      id: data['id'],
      name: data['title'],
    );
  }

  static List<CityModel> listFromJson(data) {
    return data.map<CityModel>((city) => CityModel.fromJson(city)).toList();
  }
}