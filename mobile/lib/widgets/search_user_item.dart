import 'package:flutter/material.dart';

class SearchUserItem extends StatelessWidget {
  String id;
  String username;
  String fullname;
  String avatarUrl;
  SearchUserItem(
      {required this.id,
      required this.username,
      required this.fullname,
      required this.avatarUrl,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
        maxRadius: 24,
      ),
      title: Text(fullname),
      subtitle: Text('@$username'),
    );
  }
}
