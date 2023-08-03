import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/models/contact_model.dart';
import 'package:zola/services/users.dart' as user_service;

enum UserRole {
  admin,
  member,
}

class ChatMember {
  final String name;
  final String avatarUrl;
  UserRole role;

  ChatMember(
      {required this.name,
      required this.avatarUrl,
      this.role = UserRole.member});
}

class ManageChatMemberScreen extends StatefulWidget {
  final String id;
  const ManageChatMemberScreen({required this.id, Key? key});

  @override
  _ManageChatMemberScreenState createState() => _ManageChatMemberScreenState();
}

class _ManageChatMemberScreenState extends State<ManageChatMemberScreen> {
  bool isAdmin = true;
  List<ChatMember> members = [
  ];

  List<ContactModel> memberUser = [];
  bool _loading = true;

  void _deleteMember(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa thành viên'),
          content: const Text('Bạn có chắc chắn muốn xóa thành viên này?'),
          actions: [
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa'),
              onPressed: () {
                setState(() {
                  members.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editMemberRole(int index) {
    if (isAdmin) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Chỉnh sửa vai trò'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<UserRole>(
                  title: const Text('Admin'),
                  value: UserRole.admin,
                  groupValue: members[index].role,
                  onChanged: (UserRole? value) {
                    setState(() {
                      members[index].role = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<UserRole>(
                  title: const Text('Member'),
                  value: UserRole.member,
                  groupValue: members[index].role,
                  onChanged: (UserRole? value) {
                    setState(() {
                      members[index].role = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    user_service.getUserInRoom(widget.id).then((value) {
      setState(() {
        memberUser = value;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thành viên'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: memberUser.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(memberUser[index].imageURL ?? ""),
                    ),
                    title: Text(memberUser[index].name),
                      subtitle:
                          Text(memberUser[index].role ?? "Member"),
                      trailing: isAdmin
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Iconsax.edit),
                                  onPressed: () {
                                    // _editMemberRole(index);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Iconsax.trash),
                                  onPressed: () {
                                    // _deleteMember(index);
                                  },
                                ),
                              ],
                            )
                          : null,
                  ),
                );
              },
            ),
    );
  }
}
