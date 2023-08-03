import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zola/constants.dart' as constants;
import 'package:zola/models/contact_model.dart';
import 'package:zola/models/user_model_following.dart';
import 'package:zola/services/api/api_client.dart';
import 'package:zola/utils/secure_storage_helper.dart';

import 'api/cache_api_client.dart';

const api = constants.api;
ApiCacheManager apiCacheManager = ApiCacheManager();

DioClient dioClient = DioClient();

Future<void> updateProfile(
    String? fullname, String? bio, String? avatar, String? coverImage) async {
  try {
    if (avatar != null) {
      FormData formDataAvatar = FormData.fromMap({
        'file': await MultipartFile.fromFile(avatar,
            filename: avatar.split("/").last)
      });
      await dioClient.patch("$api/user/change-avatar", formDataAvatar);
    }

    if (coverImage != null) {
      FormData formDataAvatar = FormData.fromMap({
        'file': await MultipartFile.fromFile(coverImage,
            filename: coverImage.split("/").last)
      });
      await dioClient.patch("$api/user/change-cover", formDataAvatar);
    }

    // check if fullname and bio is null
    if (fullname == null && bio == null) return;
    final data = {'fullname': fullname, 'bio': bio};
    await dioClient.patch("$api/user/update-info", data);
  } catch (e) {
    print(e);
    throw Exception('Failed to load data');
  }
}

Future<void> getUserByUsername(String username) async {
  final response = await dioClient.get("$api/user/get?username=$username");

  if (response.statusCode! == 200) {
    // If the server did return a successful response, parse the JSON.
    print("User info load");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<dynamic> getUserInfo(String username, {bool refetch = false}) async {
  var userJson = await FlutterSecureStorageHelper.read("userInfo");
  Map userMap = jsonDecode(userJson!);
  String myUsername = userMap['username'];

  final response =
      await dioClient.get("$api/user/get?username=$username&me=$myUsername");

  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    // If the server did return a successful response, parse the JSON.
    return response.data;
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<dynamic> getMyInfo() async {
  try {
    final response = await apiCacheManager.getData("$api/user/get-info");
    return response;
  } catch (e) {
    print(e);
    throw Exception('Failed to load data');
  }
}

Future<List<ContactModel>> getFriend({bool refetch = false}) async {
  try {
    final response = refetch
        ? await apiCacheManager.refetchData("$api/user/friends")
        : await apiCacheManager.getData("$api/user/friends");
    List<dynamic> data = jsonDecode(response)['data'];
    List<dynamic> data2 = data.where((e) => e != null).toList();
    List<ContactModel> result = data2.map((e) {
      return ContactModel.fromJson(e);
    }).toList();

    return result;
  } catch (e) {
    print(e);
    throw Exception('Failed to load data');
  }
}

Future<dynamic> getFollowing({bool refetch = false}) async {
  try {
    var userJson = await FlutterSecureStorageHelper.read("userInfo");
    Map userMap = jsonDecode(userJson!);
    String username = userMap['username'];
    final response = refetch
        ? await apiCacheManager
            .refetchData("$api/user/followings?username=$username")
        : await apiCacheManager
            .getData("$api/user/followings?username=$username");
    List<dynamic> data = jsonDecode(response)['data'];
    List<UserFollowingModel> result = data.map((e) {
      return UserFollowingModel.fromJson(e);
    }).toList();

    return result;
  } catch (e) {
    print(e);
    throw Exception('Failed to load data');
  }
}

Future<dynamic> getFollower({bool refetch = false}) async {
  try {
    var userJson = await FlutterSecureStorageHelper.read("userInfo");
    Map userMap = jsonDecode(userJson!);
    String username = userMap['username'];
    final response = refetch
        ? await apiCacheManager
            .refetchData("$api/user/followers?username=$username")
        : await apiCacheManager
            .getData("$api/user/followers?username=$username");
    List<dynamic> data = jsonDecode(response)['data'];
    List<UserFollowingModel> result = data.map((e) {
      return UserFollowingModel.fromJson(e);
    }).toList();

    return result;
  } catch (e) {
    print(e);
    throw Exception('Failed to load data');
  }
}

// get recommended user
Future<List<UserFollowingModel>> getRecommendedUser(
    {bool refetch = false}) async {
  try {
    final response = refetch
        ? await apiCacheManager.refetchData("$api/user/recommend-friends")
        : await apiCacheManager.getData("$api/user/recommend-friends");
    List<dynamic> data = jsonDecode(response)['data'];
    List<UserFollowingModel> result = data.map((e) {
      return UserFollowingModel.fromJson(e);
    }).toList();

    return result;
  } catch (e) {
    print(e);
    throw Exception('Failed to load data');
  }
}

Future<void> followUser(String username) async {
  final response = await dioClient.patch("$api/user/follow/$username", null);

  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    // If the server did return a successful response, parse the JSON.
    print("Followed");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> unFollowUser(String username) async {
  final response = await dioClient.patch("$api/user/unfollow/$username", null);

  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    // If the server did return a successful response, parse the JSON.
    print("Unfollowed");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<List<UserFollowingModel>> searchUser(String searchText) async {
  final response = await dioClient.get("$api/user?search=$searchText");

  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    // If the server did return a successful response, parse the JSON.
    List<dynamic> data = response.data['data'];
    List<UserFollowingModel> result = data.map((e) {
      return UserFollowingModel.fromJson(e);
    }).toList();

    return result;
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<dynamic> getUserInRoom(String roomId) async {
  try {
    final response = await dioClient.get("$api/room/user?roomId=$roomId");
    List<dynamic> data = response.data['user'];
    List<ContactModel> result = data.map((e) {
      return ContactModel.fromJson(e);
    }).toList();

    return result;
  } catch (e) {
    print(e);
    throw Exception('Failed to load data');
  }
}
