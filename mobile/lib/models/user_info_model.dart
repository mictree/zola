class UserProfileInfoModel {
  final String id;
  final String fullname;
  final String avatarUrl;
  final String coverUrl;
  final String username;
  final String bio;
  int follower = 0;
  int following = 0;
  bool isFollowing = false;
  bool isMe = false;
  String createdAt;

  UserProfileInfoModel(
      {required this.id,
      required this.fullname,
      required this.avatarUrl,
      required this.coverUrl,
      required this.username,
      this.bio = "",
      this.follower = 0,
      this.following = 0,
      this.isFollowing = false,
      this.isMe = false,
      this.createdAt = ""});

  factory UserProfileInfoModel.fromJson(Map<String, dynamic> json) {
    return UserProfileInfoModel(
      id: json['id'] ?? "",
      fullname: json['fullname'],
      avatarUrl: json['avatarUrl'] ??
          "https://w7.pngwing.com/pngs/81/570/png-transparent-profile-logo-computer-icons-user-user-blue-heroes-logo-thumbnail.png",
      coverUrl: 'coverUrl',
      username: json['username'],
    );
  }

  get value => null;
}
