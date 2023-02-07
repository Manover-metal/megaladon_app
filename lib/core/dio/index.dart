
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static late Dio _dio;

  ApiService();

  ApiService.initialize() {
     _dio = Dio();
     _dio.options.baseUrl = dotenv.env['BASE_URL']!;
  }

  static Dio get I => _dio;

  static addInterceptors(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }
}
