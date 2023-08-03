import 'dart:async';
import 'package:dio/dio.dart';
import 'package:zola/utils/secure_storage_helper.dart';
import '../../services/auth.dart' as auth_service;

class DioClient {
  late Dio _dio;
  static final DioClient _instance = DioClient._();

  DioClient._() {
    _dio = Dio();
    _setupInterceptors();
  }

  factory DioClient() {
    return _instance;
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Thêm token vào header của request
        options.headers['Authorization'] = 'Bearer ${await _getToken()}';

        // Chuyển tiếp request đến server
        return handler.next(options);
      },
      onError: (DioError e, handler) async {
        // Nếu nhận được lỗi 401 Unauthorized, thực hiện refresh token và thử lại request
        if (e.response?.statusCode == 401) {
          final newToken = await _refreshAccessToken();
          _saveToken(newToken);

          // Thêm token mới vào header của request
          final options = Options(
            method: e.requestOptions.method,
            headers: {
              ...e.requestOptions.headers,
              'Authorization': 'Bearer $newToken',
            },
          );

          // Thử lại request với token mới
          await _dio.request(e.requestOptions.path, options: options);
          return;
        }
        // Nếu không phải lỗi 401, chuyển tiếp lỗi đến handler tiếp theo
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    return _dio.get(url, queryParameters: queryParameters);
  }

  Future<Response> put(String url,
      {required Map<String, dynamic>? queryParameters}) async {
    return _dio.put(url, queryParameters: queryParameters);
  }

  Future<Response> post(String url, dynamic data) async {
    return _dio.post(url, data: data);
  }

  Future<Response> patch(String url, dynamic data) async {
    return _dio.patch(url, data: data);
  }

  Future<Response> delete(String url, dynamic data) async {
    return _dio.delete(url, data: data);
  }

  Future<String?> _getToken() async {
    // Lấy token từ storage hoặc memory
    try {
      String? token = await FlutterSecureStorageHelper.read("accessToken");
      return token;
    } catch (e) {
      return null;
    }
  }

  Future<String> _refreshAccessToken() async {
    // Thực hiện refresh token và trả về token mới hoặc null nếu refresh token thất bại
    return await auth_service.getRefreshToken();
  }

  void _saveToken(String token) async {
    // Lưu trữ token vào storage hoặc memory
    await FlutterSecureStorageHelper.write("accessToken", token);
  }
}
