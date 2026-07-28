import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/user_model.dart';

class MessageModel extends Equatable {
  const MessageModel({
    required this.id,
    required this.createdAt,
    this.text = '',
    this.user,
    this.file,
    this.fileName,
  });
  final int id;
  final String? text;
  final DateTime createdAt;
  final UserModel? user;

  /// Абсолютный URL файла с сервера (null у текстового сообщения).
  final String? file;

  /// Имя файла для показа (выводится из [file]).
  final String? fileName;

  static MessageModel fromJson(Map<String, dynamic> json) {
    final fileUrl = json['file'] as String?;
    return MessageModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      text: json['message'] as String?,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      file: fileUrl,
      fileName: fileUrl != null ? _basename(fileUrl) : null,
    );
  }

  static String _basename(String url) {
    final segments = Uri.parse(url).pathSegments;
    return segments.isNotEmpty ? segments.last : url;
  }

  static List<MessageModel> fromJsonList(data) => (data as List)
      .map<MessageModel>(
          (item) => MessageModel.fromJson(item as Map<String, dynamic>))
      .toList();

  @override
  List<Object?> get props => [id, createdAt, text, file];
}
