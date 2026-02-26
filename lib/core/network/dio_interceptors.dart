import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage storage;
  AuthInterceptor(this.storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
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
  final int maxRetries;
  final Duration baseDelay;

  RetryOnConnectionChangeInterceptor(
    this.dio, {
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Chỉ retry khi lỗi network
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    // Lấy số lần retry hiện tại từ extra
    int retryCount = requestOptions.extra['retryCount'] ?? 0;

    if (retryCount >= maxRetries) {
      return handler.next(err); // vượt quá số lần retry
    }

    retryCount++;
    requestOptions.extra['retryCount'] = retryCount;

    // Exponential backoff
    final delay = baseDelay * (1 << (retryCount - 1));
    await Future.delayed(delay);

    try {
      final response = await dio.fetch(requestOptions);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout;
  }
}
