import 'package:zola/constants.dart' as constants;
import 'package:zola/models/notification_model.dart';
import 'package:zola/services/api/api_client.dart';
import 'package:zola/utils/secure_storage_helper.dart';

const api = constants.api;
DioClient dioClient = DioClient();

Future<List<NotificationModel>> getNotification({int page =1 }) async {
  try {
    final response = await dioClient.get("$api/notification?page=$page&limit=20");

    if (response.statusCode == 200) {
      // If the server did return a successful response, parse the JSON.
      List<dynamic> data = response.data['data'];

      List<NotificationModel> result = data.map((e) {
        return NotificationModel.fromJson(e);
      }).toList();
      return result;
    } else {
      // If the server did not return a successful response, throw an error.
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to transform data ');
  }
}

Future<int> countUnreadNotification() async {
  try {
    final response = await dioClient.get("$api/notification/count-unread");

    if (response.statusCode == 200) {
      // If the server did return a successful response, parse the JSON.
      int data = response.data['data'] as int;
      return data;
    } else {
      // If the server did not return a successful response, throw an error.
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load data');
  }
}

Future<void> readNotification(String notificationId) async {
  final response =
      await dioClient.patch("$api/notification/read/$notificationId", null);

  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    // If the server did return a successful response, parse the JSON.
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to send request');
  }
}

Future<void> readAllNotification() async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");

  final response = await dioClient.patch("$api/notification/read-all", null);

  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    // If the server did return a successful response, parse the JSON.
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to send request');
  }
}

Future<void> deleteNotification(String notificationId) async {

  final response =
      await dioClient.delete("$api/notification/delete/$notificationId", null);

  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    // If the server did return a successful response, parse the JSON.
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to send request');
  }
}

Future<void> deleteAllNotification() async {
  final response = await dioClient.delete("$api/notification/delete-all", null);

  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    // If the server did return a successful response, parse the JSON.
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to send request');
  }
}
