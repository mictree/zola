enum MessageState { sending, sent, delivered, seen }

class MessageModel {
  String messageContent;
  String messageType;
  String messageTime;
  String contentType;
  String? senderImage;
  String? senderName;
  MessageState? state;
  String? tmpFilePath;
  bool isFromFile;

  MessageModel(
      {required this.messageContent,
      required this.messageType,
      required this.messageTime,
      required this.contentType,
      this.senderImage,
      this.senderName,
      this.isFromFile = false,
      this.state});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    var type = json['type'].toString();

    if (type == "image" ||
        type == "video" ||
        type == "file" ||
        type == "audio") {
      return MessageModel(
          messageContent: json['attach_files'][0]['url'],
          messageType: json['messageType'] ?? "sender",
          messageTime: json['created_at'],
          contentType: json['type'].toString(),
          senderName: json['sender']['fullname'],
          senderImage: json['sender']['avatarUrl']);
    }

    return MessageModel(
        messageContent: json['content'] ?? json['message'],
        messageType: json['messageType'],
        messageTime: json['created_at'],
        contentType: json['type'].toString() == "message"
            ? "text"
            : json['type'].toString(),
        senderName: json['sender']['fullname'],
        senderImage: json['sender']['avatarUrl']);
  }
}
