import 'dart:convert';

import 'package:zola/models/user_info_model.dart';

class PostModel {
  final String id;
  final List<String>? imgUrl;
  final String? videoUrl;
  final UserProfileInfoModel author;
  final String content;
  int totalLike;
  int totalComment;
  final String createAt;
  bool isLiked;

  PostModel(
      {required this.id,
      this.imgUrl,
      this.videoUrl,
      required this.author,
      required this.content,
      required this.totalLike,
      required this.totalComment,
      required this.createAt,
      required this.isLiked});

  factory PostModel.fromRawJson(String str) =>
      PostModel.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

  factory PostModel.fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> attachFiles = json['attach_files'];
      List<String> imageUrls = [];
      String videoUrl = "";

      if (attachFiles.length == 1 &&
          attachFiles[0]['resource_type'] == 'video') {
        videoUrl = attachFiles[0]['url'];
      } else {
        for (final file in attachFiles) {
          if (file['resource_type'] == 'image') {
            imageUrls.add(file['url']);
          }
        }
      }

      return PostModel(
        id: json["_id"],
        imgUrl: imageUrls,
        videoUrl: videoUrl,
        author: UserProfileInfoModel.fromJson(json["author"]),
        content: json["content"],
        totalLike: json["totalLike"],
        totalComment: json["totalComment"],
        createAt: json["created_at"],
        isLiked: json["isLike"],
      );
    } catch (e) {
      print("Fail to transform json to PostModel: $e");
      throw e;
    }
  }
}
