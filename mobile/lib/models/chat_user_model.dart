class ChatUserModel {
  String id;
  String name;
  String messageText;
  String imageURL;
  String time;
  bool isGroup;
  String sender;
  String messageType;
  int memberCount = 0;

  ChatUserModel(
      {required this.id,
      required this.name,
      required this.messageText,
      required this.imageURL,
      required this.time,
      required this.sender,
      required this.messageType,
      this.isGroup = false,
      this.memberCount = 0});

  factory ChatUserModel.fromJson(Map<String, dynamic> json, String username) {
    try {
      final dynamic lastMessage = json['last_message'];
      final List<dynamic> users = json['users'];

      String messageText = "";
      String time = "";
      String sender = "";
      String messageType = "";

      if (lastMessage != null) {
        messageText = lastMessage["content"] ?? "";
        sender = lastMessage["sender_fullname"] ?? "";
        messageType = lastMessage["type"] ?? "";
        time = lastMessage["created_at"] ?? "";
      }

      String imageURL = "";
      String name = "";

      // Kiểm tra kích thước của mảng users trước khi truy cập
      if (users.length >= 2) {
        String otherUserUsername;
        if (users[0]["username"] != username) {
          otherUserUsername = users[0]["username"];
        } else {
          otherUserUsername = users[1]["username"];
        }

        imageURL = users.firstWhere(
                (user) => user["username"] == otherUserUsername,
                orElse: () => {})["avatarUrl"] ??
            "";
        if (users.length == 2) {
          name = users.firstWhere(
              (user) => user["username"] == otherUserUsername,
              orElse: () => {})["fullname"];
        }
		else {
		  name = json["name"] ?? "Không tên";
		}
      }

      return ChatUserModel(
        id: json["_id"],
        name: name,
        sender: sender,
        messageText: messageText,
        messageType: messageType,
        imageURL: imageURL,
        time: time,
        isGroup: json["isRoom"] ?? false,
        memberCount: json["users"].length ?? 0,
      );
    } catch (e) {
      print(e);
      print("Failed to transform data");
      throw Exception('Failed to transform data');
    }
  }
}
