import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zola/constants.dart' as constants;
import 'package:zola/models/chat_user_model.dart';
import 'package:zola/utils/secure_storage_helper.dart';

import 'api/api_client.dart';
import 'api/cache_api_client.dart';

const api = constants.api;

ApiCacheManager apiCacheManager = ApiCacheManager();
DioClient dioClient = DioClient();

Future<String> testCache() async {
  try {
    String response = await apiCacheManager.getData("$api/room");
    List<dynamic> jsonData = json.decode(response)["Rooms"];
    print("Ok_");

    return "response";
  } catch (e) {
    print("error");
    print(e);
    return "null";
  }
}

Future<List<ChatUserModel>> getRoom({bool refetch = false}) async {
  try {
    var userJson = await FlutterSecureStorageHelper.read("userInfo");
    Map userMap = jsonDecode(userJson!);
    String username = userMap['username'];
    final response = refetch
        ? await apiCacheManager.refetchData("$api/room")
        : await apiCacheManager.getData("$api/room");
    List<dynamic> data = jsonDecode(response)['Rooms'];
    List<ChatUserModel> result = data.map((e) {
      return ChatUserModel.fromJson(e, username);
    }).toList();

    return result;
  } catch (e) {
    // print(e);
    throw Exception('Failed to load data');
  }
}

Future<ChatUserModel> getRoomInfoById(String id, {bool refetch = false}) async {
  try {
    var userJson = await FlutterSecureStorageHelper.read("userInfo");
    Map userMap = jsonDecode(userJson!);
    String username = userMap['username'];
    final response = refetch
        ? await apiCacheManager.refetchData("$api/room/$id")
        : await apiCacheManager.getData("$api/room/$id");
    dynamic data = jsonDecode(response)['room'];
    ChatUserModel result = ChatUserModel.fromJson(data, username);
    return result;
  } catch (e) {
    throw Exception('Failed to load data');
  }
}

Future<dynamic> getAllRoomId() async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");

  final response = await dioClient.get("$api/room");

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    List<dynamic> data = response.data['Rooms'];
    List<String> result = data.map((e) {
      return e['_id'].toString();
    }).toList();

    return result;
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<List<ChatUserModel>> getGroupChat({bool refetch = false}) async {
  try {
    var userJson = await FlutterSecureStorageHelper.read("userInfo");
    Map userMap = jsonDecode(userJson!);
    String username = userMap['username'];
    final response = refetch
        ? await apiCacheManager.refetchData("$api/room/group")
        : await apiCacheManager.getData("$api/room/group");
    List<dynamic> data = jsonDecode(response)['data'];
    List<ChatUserModel> result = data.map((e) {
      return ChatUserModel.fromJson(e, username);
    }).toList();
    return result;
  } catch (e) {
    throw Exception('Failed to load data');
  }

//   String? token = await FlutterSecureStorageHelper.read("accessToken");

//   final response = await http.get(Uri.parse("$api/room/group"), headers: {
//     "Content-Type": "application/json",
//     "Accept": "*/*",
//     'Authorization': 'Bearer $token'
//   });

//   if (response.statusCode == 200) {
//     // If the server did return a successful response, parse the JSON.
//     String username = await FlutterSecureStorageHelper.getUsername();
//     List<dynamic> data = jsonDecode(response.body)['data'];
//     List<ChatUserModel> result = data.map((e) {
//       return ChatUserModel.fromJson(e, username);
//     }).toList();
//     return result;
//   } else {
//     // If the server did not return a successful response, throw an error.
//     throw Exception('Failed to load data');
//   }
}

Future<String> createGroupChat(String name, List<String> userList) async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");

  var body = json.encode({
    "name": userList.length > 1 ? name : null,
    "users": userList,
    "isRoom": userList.length > 1 ? true : false
  });
  final response = await http.post(Uri.parse("$api/room/create"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        'Authorization': 'Bearer $token'
      },
      body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a successful response, parse the JSON.
    print("Create group chat success");
    return jsonDecode(response.body)['data']['_id'];
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> changeRoomName(String roomId, String name) async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");

  var body = json.encode({
    "name": name,
  });

  final response =
      await http.patch(Uri.parse("$api/room/change-room-name/$roomId"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            'Authorization': 'Bearer $token'
          },
          body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a successful response, parse the JSON.
    print("Change room chat success");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to request data');
  }
}

Future<void> leaveRoom(String roomId) async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");

  final response =
      await http.patch(Uri.parse("$api/room/leave-room/$roomId"), headers: {
    "Content-Type": "application/json",
    "Accept": "*/*",
    'Authorization': 'Bearer $token'
  });

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a successful response, parse the JSON.
    print("Leave room chat success");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> deleteRoom(String roomId) async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");

  final response =
      await http.delete(Uri.parse("$api/room/delete-room/$roomId"), headers: {
    "Content-Type": "application/json",
    "Accept": "*/*",
    'Authorization': 'Bearer $token'
  });

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a successful response, parse the JSON.
    print("Delete room chat success");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> addUserToRoom(String roomId, List<String> users) async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");
  var body = json.encode({"users": users});
  final response = await http.patch(Uri.parse("$api/room/add-user/$roomId"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        'Authorization': 'Bearer $token'
      },
      body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a successful response, parse the JSON.
    print("Add users to room success");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> removeUserToRoom(String roomId, List<String> users) async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");
  var body = json.encode({"users": users});
  final response = await http.patch(Uri.parse("$api/room/remove-user/$roomId"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        'Authorization': 'Bearer $token'
      },
      body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a successful response, parse the JSON.
    print("Remove users to room success");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}
