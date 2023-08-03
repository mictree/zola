import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/models/chat_user_model.dart';
import 'package:zola/theme.dart';
import 'package:zola/services/room.dart' as room_service;
import 'package:zola/widgets/group_avatar.dart';

class ChatRoomInfoScreen extends StatefulWidget {
  final String id;

  ChatRoomInfoScreen({required this.id, super.key});

  @override
  State<ChatRoomInfoScreen> createState() => _ChatRoomInfoScreenState();
}

class _ChatRoomInfoScreenState extends State<ChatRoomInfoScreen> {
  String name = "";

  late Future<ChatUserModel> _roomInfo;

  Future<ChatUserModel> getRoomInfo() async {
    return await room_service.getRoomInfoById(widget.id);
  }

  void refetch() async {
    var data = await getRoomInfo();
    setState(() {
      _roomInfo = Future.value(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _roomInfo = getRoomInfo();
  }

  void showChangeName(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Đổi tên nhóm"),
          content: TextField(
            onChanged: (value) {
              name = value;
            },
            decoration: const InputDecoration(
              hintText: "Nhập tên nhóm",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                await room_service.changeRoomName(widget.id, name);
                if (context.mounted) {
                  refetch();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Đổi tên"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin nhóm chat")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _roomInfo,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            // rectangle top left and right
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 220,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        width: 50,
                                        child: Divider(
                                          thickness: 5,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "Chọn ảnh",
                                        style: GoogleFonts.getFont(
                                            primaryFont,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Divider(),
                                      const SizedBox(height: 20),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.camera_alt),
                                        title: Text(
                                          "Chụp ảnh",
                                          style: GoogleFonts.getFont(
                                              primaryFont,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.image),
                                        title: Text(
                                          "Chọn ảnh từ thư viện",
                                          style: GoogleFonts.getFont(
                                              primaryFont,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: snapshot.data.isGroup
                              ? GroupAvatar(
                                  radius: 40,
                                  name: snapshot.data.name,
                                  imageUrl: snapshot.data.imageURL,
                                )
                              : CachedNetworkImage(
                                  imageUrl: snapshot.data.imageURL,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data.name,
                              style: const TextStyle(fontSize: 20)),
                          snapshot.data.isGroup
                              ? Text(
                                  "Thành viên: ${snapshot.data.memberCount}",
                                  style: const TextStyle(fontSize: 16))
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        snapshot.data.isGroup
                            ? Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    context.push(RouteConst.addMemberRoom
                                        .replaceAll('id', '1'));
                                  },
                                  child: const ListTile(
                                    leading: Icon(Icons.people),
                                    title: Text("Thêm thành viên"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showChangeName(context);
                                  },
                                  child: const ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text("Đổi tên nhóm"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.push(RouteConst
                                        .manageChatMember
                                        .replaceAll(":id", widget.id));
                                  },
                                  child: ListTile(
                                    leading: const Icon(Iconsax.people),
                                    title: Text(
                                        "Xem thành viên (${snapshot.data.memberCount})"),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Divider(),
                                GestureDetector(
                                  onTap: () {
                                    room_service.leaveRoom(widget.id);
                                    context.go(RouteConst.chat);
                                  },
                                  child: const ListTile(
                                    leading: Icon(
                                      Iconsax.logout4,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      "Rời khỏi nhóm",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ])
                            : const SizedBox(),
                        GestureDetector(
                          onTap: () {
                            room_service.deleteRoom(widget.id);
                            context.go(RouteConst.chat);
                          },
                          child: const ListTile(
                            leading: Icon(
                              Iconsax.trash4,
                              color: Colors.red,
                            ),
                            title: Text("Xóa cuộc trò chuyện",
                                style: TextStyle(color: Colors.red)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
