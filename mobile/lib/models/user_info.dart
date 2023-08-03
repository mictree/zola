class UserInfo {
  String id;
  String fullname;
  String avatarUrl;
  String username;
  String coverUrl;
  int followers = 0;
  int followings = 0;

  UserInfo(
      {required this.id,
      required this.fullname,
      required this.avatarUrl,
      required this.username,
      this.coverUrl = "https://picsum.photos/200",
      this.followers = 0,
      this.followings = 0});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'avatarUrl': avatarUrl,
      'username': username,
      'coverUrl': coverUrl,
    };
  }
}
