class UserModel {
  final int id;
  final String name;
  final String? phone;
  final String? photo;
  final int countOrders;

  UserModel(this.id, this.name, this.phone, this.photo, this.countOrders);

  static UserModel fromJson(data) {
    return UserModel(
      data['id'],
      data['name'],
      data['phone'],
      data['photo'],
      data['count_orders']
    );
  }
}