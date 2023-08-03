class UserFollowingModel {
  final String id;
  final String fullname;
  final String avatarUrl;
  final String username;
  final String bio;
  final bool isFollowing;

  UserFollowingModel(
      {required this.id,
      required this.fullname,
      required this.avatarUrl,
      required this.username,
      this.isFollowing = false,
      this.bio = ""});

  factory UserFollowingModel.fromJson(Map<String, dynamic> json) {
    return UserFollowingModel(
      id: json['id'] ?? json['_id'] ?? "",
      fullname: json['fullname'],
      avatarUrl: json['avatarUrl'] ?? "",
      username: json['username'],
	  bio: json['contact_info']['bio'] ?? " ",
      isFollowing: json['isFollowing'] ?? false,
    );
  }

  get value => null;
}
