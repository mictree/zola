import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zola/constants.dart' as constants;
import 'package:zola/utils/secure_storage_helper.dart';

const api = constants.api;

Future<String> startCall(String roomId) async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");

  final response = await http.get(Uri.parse("$api/notification/call/$roomId"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      });

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    dynamic data = jsonDecode(response.body)["callToken"];

    return data;
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}
