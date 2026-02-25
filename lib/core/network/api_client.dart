// lib/core/network/api_client.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import 'dio_interceptors.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  factory ApiClient.create({required String baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.addAll([
      // Thứ tự: Auth -> Retry -> Logging (để log sau cùng)
      AuthInterceptor(SecureStorage()),                   // Bearer token (nếu có)
      RetryOnConnectionChangeInterceptor(dio),            // Retry/backoff
      LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return ApiClient._(dio);
  }

  // -------------------------
  // Generic HTTP helpers
  // -------------------------
  Future<T> getRequest<T>({
    required String path,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    CancelToken? cancelToken,
    required T Function(dynamic data) parser,
  }) async {
    final res = await dio.get(
      path,
      queryParameters: query,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
    return parser(res.data);
  }

  Future<T> postRequest<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    CancelToken? cancelToken,
    required T Function(dynamic data) parser,
  }) async {
    final res = await dio.post(
      path,
      data: body,
      queryParameters: query,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
    return parser(res.data);
  }

  Future<T> putRequest<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    CancelToken? cancelToken,
    required T Function(dynamic data) parser,
  }) async {
    final res = await dio.put(
      path,
      data: body,
      queryParameters: query,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
    return parser(res.data);
  }

  Future<T> deleteRequest<T>({
    required String path,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    CancelToken? cancelToken,
    required T Function(dynamic data) parser,
  }) async {
    final res = await dio.delete(
      path,
      queryParameters: query,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
    return parser(res.data);
  }

  /// Upload multipart (nếu cần)
  Future<T> uploadMultipart<T>({
    required String path,
    required FormData formData,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    required T Function(dynamic data) parser,
  }) async {
    final res = await dio.post(
      path,
      data: formData,
      queryParameters: query,
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: 'multipart/form-data',
          if (headers != null) ...headers,
        },
      ),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
    return parser(res.data);
  }
}
