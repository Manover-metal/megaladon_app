import 'package:dio/dio.dart';
import 'package:megaladon/core/image/platform_file.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/support_ticket_model.dart';

/// Обращения в поддержку: POST/GET /support/tickets.
class SupportRepository {
  Future<List<SupportTicketModel>> tickets() =>
      ApiService.I.get<dynamic>('/support/tickets').then((value) => [
            for (final json in value.data['list'] as List<dynamic>)
              SupportTicketModel.fromJson(json as Map<String, dynamic>),
          ]);

  /// Multipart: message + screenshots[] (до трёх). Возвращает текст ответа
  /// сервера для снекбара.
  Future<String?> create(String message, List<PlatformFile> screenshots) async {
    final files = <MultipartFile>[];
    for (final file in screenshots) {
      if (file.path != null) {
        files
            .add(await MultipartFile.fromFile(file.path!, filename: file.name));
      } else if (file.bytes != null) {
        files.add(MultipartFile.fromBytes(file.bytes!, filename: file.name));
      }
    }
    final data = FormData.fromMap({
      'message': message,
      if (files.isNotEmpty) 'screenshots': files,
    });
    final response =
        await ApiService.I.post<dynamic>('/support/tickets', data: data);
    return response.data?['message'] as String?;
  }
}
