import 'package:zola/models/user_info_model.dart';

class CommentModel {
  final String id;
  final String postId;
  final String content;
  final DateTime createdAt;
  final UserProfileInfoModel author;
  int totalLike;
  int totalRely;
  bool isLiked;

  CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.author,
    this.totalLike = 0,
    this.totalRely = 0,
    this.isLiked = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    print('json $json');
    return CommentModel(
      id: json["_id"],
      postId: json["postId"],
      content: json["content"],
      createdAt: DateTime.parse(json["created_at"]),
      author: UserProfileInfoModel.fromJson(json["author"]),
      totalLike: json["totalLike"],
      totalRely: json["totalReply"],
      isLiked: json["isLike"],
    );
  }
}
