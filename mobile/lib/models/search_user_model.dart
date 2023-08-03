class SearchUserModel {
  String id;
  String userId;
  String fullname;
  String username;
  String avatarUrl;

  SearchUserModel({
    required this.id,
    required this.userId,
    required this.fullname,
    required this.username,
    required this.avatarUrl,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    try {
      // check if json["searchUser"] is null
      if (json["searchUser"] == null) {
        return SearchUserModel(
          id: json["_id"],
          userId: "",
          fullname: "",
          username: "",
          avatarUrl: "",
        );
      }
      return SearchUserModel(
        id: json["_id"],
        userId: json["searchUser"]["_id"],
        fullname: json["searchUser"]["fullname"],
        username: json["searchUser"]["username"],
        avatarUrl: json["searchUser"]["avatarUrl"],
      );
    } catch (e) {
      print(e);
      throw Exception('Failed to tranform data');
    }
  }
}
