import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'api_client.dart';

class ApiCacheManager {
  late CacheManager _cacheManager;
  final DioClient _dioClient = DioClient();

  ApiCacheManager() {
    _cacheManager = CacheManager(Config(
      'my_custom_cache_key',
      stalePeriod: const Duration(days: 1),
    ));
  }

  Future<String> getData(String url) async {
    // Kiểm tra xem dữ liệu đã được lưu trữ trong cache hay chưa
    final fileInfo = await _cacheManager.getFileFromCache(url);
    if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
      // Nếu tìm thấy dữ liệu trong cache và nó vẫn còn hiệu lực, trả về dữ liệu trong cache
      final file = fileInfo.file;
      final data = await file.readAsString();
      return data;
    } else {
      // Nếu không tìm thấy dữ liệu trong cache hoặc nó hết hạn, yêu cầu dữ liệu mới từ API
      final response = await _dioClient.get(url);
      final responseData = response.data;
      final binaryData = Uint8List.fromList(utf8.encode(json.encode(
          responseData))); // Chuyển đổi đối tượng JSON sang chuỗi dữ liệu nhị phân // Chuyển đổi đối tượng JSON sang chuỗi dữ liệu nhị phân

      // Lưu trữ dữ liệu mới vào cache
      await _cacheManager.putFile(
        url,
        binaryData,
        fileExtension: 'json',
      );
      // Trả về dữ liệu mới
      return json.encode(response.data);
    }
  }

  Future<String> refetchData(String url) async {
    // Xóa dữ liệu đã lưu trữ trong cache cho đường dẫn url
    await _cacheManager.removeFile(url);

    // Yêu cầu dữ liệu mới từ API
    final response = await _dioClient.get(url);
    final responseData = response.data;
    final binaryData =
        Uint8List.fromList(utf8.encode(json.encode(responseData)));

    // Lưu trữ dữ liệu mới vào cache
    await _cacheManager.putFile(
      url,
      binaryData,
      fileExtension: 'json',
    );

    // Trả về dữ liệu mới
    return json.encode(responseData);
  }

  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}
