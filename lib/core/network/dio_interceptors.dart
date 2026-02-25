import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage storage;
  AuthInterceptor(this.storage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read('auth_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

/// Retry đơn giản khi lỗi kết nối (tuỳ chọn)
class RetryOnConnectionChangeInterceptor extends Interceptor {
  final Dio dio;
  RetryOnConnectionChangeInterceptor(this.dio);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.type == DioErrorType.connectionError) {
      try {
        // thử lại 1 lần
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (_) {
        // let it fall through
      }
    }
    super.onError(err, handler);
  }
}
