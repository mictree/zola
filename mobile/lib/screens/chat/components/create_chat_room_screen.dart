import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/models/contact_model.dart';
import 'package:zola/services/room.dart' as room_service;
import 'package:zola/services/users.dart' as user_service;

import '../../../widgets/loading_dialog.dart';

class CreateChatRoomScreen extends StatefulWidget {
  const CreateChatRoomScreen({Key? key}) : super(key: key);

  @override
  _CreateChatRoomScreenState createState() => _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
  List<ContactModel> selectedUsers = [];
  List<ContactModel> chatUsers = [];
  bool _loading = true;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user_service.getFriend().then((value) {
      setState(() {
        chatUsers = value;
        _loading = false;
      });
    });

    user_service.getFriend(refetch: true).then((value) {
      setState(() {
        chatUsers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo nhóm chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Tên nhóm chat',
              style: GoogleFonts.notoSans(
                fontSize: 24.0,
              ),
            ),
            TextField(
              controller: _nameController,
            ),
            const SizedBox(height: 16.0),
            !_loading
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatUsers.length,
                      itemBuilder: (context, index) {
                        final user = chatUsers[index];
                        return Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: Text(
                                user.name,
                                style: GoogleFonts.notoSans(
                                  fontSize: 16.0,
                                ),
                              ),
                              checkColor: Colors.black,
                              activeColor: Colors.white,
                              value: selectedUsers.contains(user),
                              secondary: CircleAvatar(
                                radius: 24.0,
                                backgroundImage:
                                    user.imageURL != "" || user.imageURL != null
                                        ? NetworkImage(user.imageURL)
                                        : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedUsers.add(user);
                                  } else {
                                    selectedUsers.remove(user);
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedUsers.isEmpty
            ? null
            : () async {
                // TODO: Create the chat room with the selected users
                try {
                  List<String> selectedUserIds =
                      selectedUsers.map((e) => e.id).toList();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    useRootNavigator: false,
                    builder: (BuildContext context) {
                      return LoadingDialog();
                    },
                  );

                  String roomId = await room_service.createGroupChat(
                      _nameController.text, selectedUserIds);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    context.push(RouteConst.message.replaceAll(":id", roomId));
                  }
                } catch (e) {
                  // Snack bar for error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Đã có lỗi xảy ra, vui lòng thử lại!"),
                    ),
                  );
                }
              },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
