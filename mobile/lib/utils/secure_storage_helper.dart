import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageHelper {
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  static final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  static Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  static Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    await storage.deleteAll();
  }

  static Future<String> getUsername() async {
    var userJson = await storage.read(key: 'userInfo');
    Map userMap = jsonDecode(userJson!);
    String username = userMap['username'];
    return username;
  }

  static Future<String> getUserId() async {
	var userJson = await storage.read(key: 'userInfo');
	Map userMap = jsonDecode(userJson!);
	String userId = userMap['id'];
	return userId;
  }
}
