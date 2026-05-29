import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/user_model.dart';

class MessageModel extends Equatable {
  const MessageModel(
      {required this.id, required this.createdAt, this.text = '', this.user});
  final int id;
  final String? text;
  final DateTime createdAt;
  final UserModel? user;

  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      text: json['message'] as String?,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null);

  static List<MessageModel> fromJsonList(data) => (data as List)
      .map<MessageModel>(
          (item) => MessageModel.fromJson(item as Map<String, dynamic>))
      .toList();

  @override
  List<Object?> get props => [id, createdAt, text];
}
