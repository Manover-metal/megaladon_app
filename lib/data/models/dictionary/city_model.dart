class CityModel {
  final int id;
  final String name;

  CityModel({required this.id, required this.name});

  static CityModel fromJson(data) {
    try {
      return CityModel(
        id: data['id'],
        name: data['name'],
      );
    } catch(e) {
      return CityModel.nothing;
    }
  }

  static List<CityModel> listFromJson(data) {
    return data.map<CityModel>((city) => CityModel.fromJson(city)).toList();
  }

  static CityModel get nothing => CityModel(id: -1, name: '');


}