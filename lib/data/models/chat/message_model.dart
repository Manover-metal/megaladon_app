import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/user_model.dart';

class MessageModel extends Equatable {

  final int id;
  final String? text;
  final DateTime createdAt;
  final UserModel? user;



  MessageModel({
    required this.id,
    required this.createdAt,
    this.text = '',
    this.user
  });

  static MessageModel fromJson(Map json){
    return MessageModel(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        text: json['message'],
        user: json['user'] != null? UserModel.fromJson(json['user']) : null
    );
  }

  static List<MessageModel> fromJsonList(data) {
    return data.map<MessageModel>((value) {
      return MessageModel.fromJson(value);
    }).toList();
  }

  @override
  List<Object?> get props => [id, createdAt, text];
}