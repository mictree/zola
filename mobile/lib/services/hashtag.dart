import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zola/constants.dart' as constants;

import 'api/api_client.dart';
import 'api/cache_api_client.dart';

const api = constants.api;

Dio dio = Dio();
ApiCacheManager apiCacheManager = ApiCacheManager();
DioClient dioClient = DioClient();

Future<List<dynamic>> getTrendyHashtag({bool refetch = true}) async {
  try {
    final response = refetch
        ? await apiCacheManager.refetchData("$api/hashtag/trending")
        : await apiCacheManager.getData("$api/hashtag/trending");
    List<dynamic> data = jsonDecode(response)['data'];
    return data;
  } catch (e) {
    print(e);
    return [];
  }
}
