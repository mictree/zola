import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

import 'package:zola/constants.dart' as constants;
import 'package:zola/models/user_info.dart';
import 'package:zola/services/api/cache_api_client.dart';
import 'package:zola/utils/secure_storage_helper.dart';

const api = constants.api;
ApiCacheManager apiCacheManager = ApiCacheManager();

Future<String> login(String email, String password) async {
  // ignore: prefer_typing_uninitialized_variables
  String? token = await FirebaseMessaging.instance.getToken();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  var body = json.encode({
    'email': email,
    'password': password,
    'deviceName': androidInfo.model.toString(),
    'fcm_token': token.toString()
  });

  final response = await http.post(Uri.parse("$api/auth/login"),
      headers: {"Content-Type": "application/json", "Accept": "*/*"},
      body: body);

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    var jsonResponse = jsonDecode(response.body);

    await FlutterSecureStorageHelper.write("isLogin", "true");

    // save token to secure storage
    await FlutterSecureStorageHelper.write(
        "accessToken", jsonResponse["token"].toString());
    await FlutterSecureStorageHelper.write(
        "refreshToken", response.headers["set-cookie"].toString());

    UserInfo useInfo = UserInfo(
        id: jsonResponse["user"]["id"].toString(),
        fullname: jsonResponse["user"]["fullname"].toString(),
        avatarUrl: jsonResponse["user"]["avatarUrl"].toString(),
        username: jsonResponse["user"]["username"].toString(),
        coverUrl: jsonResponse["user"]["coverUrl"].toString());
    // save user info to secure storage
    await FlutterSecureStorageHelper.write(
        "userInfo", jsonEncode(useInfo.toJson()));

    await FlutterSecureStorageHelper.write("isLogin", "true");

    return "success";
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> signUp(
    String email, String password, String fullname, String birthday) async {
  try {
    var body = json.encode({
      'email': email,
      'password': password,
      'fullname': fullname,
      'birthday': birthday
    });

    final response = await http.post(Uri.parse("$api/auth/register"),
        headers: {"Content-Type": "application/json", "Accept": "*/*"},
        body: body);

    if (response.statusCode == 200) {
      // If the server did return a successful response, parse the JSON.
    } else {
      // If the server did not return a successful response, throw an error.
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Request failed');
  }
}

Future<void> logout() async {
  try {
    String? token = await FlutterSecureStorageHelper.read("accessToken");
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    var body = json.encode({'fcm_token': fcmToken});

    final response = await http.post(Uri.parse("$api/auth/logout"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
          'Authorization': 'Bearer $token'
        },
        body: body);

    await FlutterSecureStorageHelper.deleteAll();
    await apiCacheManager.clearCache();
    await Get.deleteAll();
  } catch (e) {
    throw Exception('Request failed');
  }
}

Future<String> getRefreshToken() async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");
  final response = await http.get(Uri.parse("$api/auth/reset-token"), headers: {
    "Content-Type": "application/json",
    "Accept": "*/*",
    'Authorization': 'Bearer $token'
  });

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse["accessToken"].toString();
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to log out');
  }
}