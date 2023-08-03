class ContactModel {
  String id;
  String name;
  String imageURL;
  String username;
  String? role;
  ContactModel(
      {required this.id,
      required this.name,
      required this.imageURL,
      required this.username,
      this.role});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    String avatarUrl = json['avatarUrl'] ?? "";
    return ContactModel(
        id: json["_id"],
        name: json['fullname'],
        imageURL: avatarUrl,
        username: json['username'],
		role: json['role'] ?? "",
		);
  }
}
