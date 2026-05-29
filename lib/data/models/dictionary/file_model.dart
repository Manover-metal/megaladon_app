class FileModel {
  FileModel(
      {required this.id,
      required this.url,
      required this.name,
      required this.active});
  final int id;
  final String url;
  final String name;
  final bool active;

  static FileModel fromJson(data) => FileModel(
      id: data['id'] as int,
      url: data['url'] as String,
      name: (data['url'] as String).split('/').last,
      active: data['active'] as bool);

  static List<FileModel> listFromJson(data) => (data as List)
      .map<FileModel>(
          (item) => FileModel.fromJson(item as Map<String, dynamic>))
      .toList();
}
