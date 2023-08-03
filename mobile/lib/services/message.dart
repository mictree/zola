import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zola/constants.dart' as constants;
import 'package:zola/models/message_model.dart';
import 'package:zola/utils/secure_storage_helper.dart';

import 'api/cache_api_client.dart';

const api = constants.api;
Dio dio = Dio();
ApiCacheManager apiCacheManager = ApiCacheManager();

Future<List<MessageModel>> getMessageFromRoom(String roomId,
    {bool refetch = false}) async {
  try {
    final response = refetch
        ? await apiCacheManager.refetchData("$api/message/find/$roomId")
        : await apiCacheManager.getData("$api/message/find/$roomId");
    List<dynamic> data = jsonDecode(response)['messages'];

    List<MessageModel> result = data.map((e) {
      return MessageModel.fromJson(e);
    }).toList();

    return result;
  } catch (e) {
    throw Exception('Failed to load data');
  }
}

Future<MessageModel> sendFileMessage(
    {required String roomId,
    required String type,
    String? image,
    String? video,
    String? audio,
    String? file}) async {
  String? token = await FlutterSecureStorageHelper.read("accessToken");
  var headers = {'Authorization': 'Bearer $token'};

  final formData = FormData.fromMap({'roomId': roomId, 'type': type});
  print('send file message id: $roomId , type: $type');
  switch (type) {
    case 'image':
      formData.files.add(MapEntry(
          'attach_files',
          await MultipartFile.fromFile(image!,
              filename: image.split("/").last)));
      break;
    case 'video':
      formData.files.add(MapEntry(
          'attach_files',
          await MultipartFile.fromFile(video!,
              filename: video.split("/").last)));
      break;
    case 'audio':
      formData.files.add(MapEntry(
          'attach_files',
          await MultipartFile.fromFile(audio!,
              filename: audio.split("/").last)));
      break;
    case 'file':
      formData.files.add(MapEntry(
          'attach_files',
          await MultipartFile.fromFile(audio!,
              filename: audio.split("/").last)));
      break;
    default:
  }

  final response = await dio.post('$api/message/send-file',
      data: formData, options: Options(headers: headers));

  if (response.statusCode == 201 || response.statusCode == 200) {
    return MessageModel.fromJson(response.data['data']);
  } else {
    throw Exception('Failed post data');
  }
}
