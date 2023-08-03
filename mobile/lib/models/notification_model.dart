class NotificationModel {
  String id;
  String message;
  String type;
  String postId;
  bool isRead;
  DateTime createdAt;
  String avatarUrl;
  String content;

  NotificationModel({
    required this.id,
    required this.message,
    required this.type,
    required this.postId,
    required this.isRead,
    required this.avatarUrl,
    required this.createdAt,
    required this.content,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      message: json['message'],
      type: json['type'],
      postId: json['postId']['_id'],
      isRead: json['isRead'],
      avatarUrl: json['author']['avatarUrl'] ?? "https://w7.pngwing.com/pngs/81/570/png-transparent-profile-logo-computer-icons-user-user-blue-heroes-logo-thumbnail.png",
      createdAt: DateTime.parse(json['createdAt']),
      content: json['postId']['content'],
    );
  }
}
