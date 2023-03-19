class FileModel {
  final int id;
  final String url;
  final String name;

  FileModel({
    required this.id,
    required this.url,
    required this.name
  });

  static FileModel fromJson(data) {
    return FileModel(
      id: data['id'],
      url: data['url'],
      name: data['url'].split('/').last
    );
  }

  static List<FileModel> listFromJson(data) {
    return data.map<FileModel>((file) => FileModel.fromJson(file)).toList();
  }

}