import 'dart:convert';

import 'package:zola/constants.dart' as constants;
import 'package:zola/models/search_text_model.dart';
import 'package:zola/models/search_user_model.dart';
import 'package:zola/services/api/cache_api_client.dart';

import 'api/api_client.dart';

const api = constants.api;
DioClient dioClient = DioClient();
ApiCacheManager apiCacheManager = ApiCacheManager();

Future<void> createSearchTextHistory(String text) async {
  final response =
      await dioClient.post("$api/search-history/text", {"keyword": text});
  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    print("search text created");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<List<SearchTextModel>> getSearchTextHistory() async {
  try {
    final response = await apiCacheManager.getData("$api/search-history/text");
    List<dynamic> data = jsonDecode(response)['data'];
    List<dynamic> data2 = data.where((e) => e != null).toList();
    List<SearchTextModel> result = data2.map((e) {
      return SearchTextModel.fromJson(e);
    }).toList();

    return result;
  } catch (e) {
    print(e);
    return [];
  }
}

// create search user history
Future<void> createSearchUserHistory(String userId) async {
  final response =
      await dioClient.post("$api/search-history/user", {"userId": userId});
  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    print("search user created");
  } else if (response.statusCode == 400) {
    print("user not found");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

// user search history
Future<List<SearchUserModel>> getSearchUserHistory() async {
  try {
    final response = await apiCacheManager.getData("$api/search-history/user");
    List<dynamic> data = jsonDecode(response)['data'];
    List<dynamic> data2 = data.where((e) => e != null).toList();
    List<SearchUserModel> result = data2.map((e) {
      return SearchUserModel.fromJson(e);
    }).toList();

    return result;
  } catch (e) {
    print(e);
    return [];
  }
}

// create delete search text history
Future<void> deleteSearchHistory(String id) async {
  final response = await dioClient.delete("$api/search-history/$id", null);
  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    print("search text deleted");
  } else if (response.statusCode == 400) {
    print("object not found");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}
