class ExecutorModel {
  final int id;
  final String name;
  final String rating;

  ExecutorModel(this.id, this.name, this.rating);

  static ExecutorModel fromJson(data) {
    return ExecutorModel(
        data['id'],
        data['name'],
        data['rating'],
    );
  }
}