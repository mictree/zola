import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/controller/auth_controller.dart';
import 'package:zola/models/chat_user_model.dart';
import 'package:zola/services/socket_service.dart';
import 'package:zola/theme.dart';
import 'package:zola/widgets/conversation_item.dart';
import 'package:zola/services/room.dart' as room_service;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  SocketService socketService = Get.find<SocketService>();
  final userInfo = Get.find<AuthController>().getUserInfo();

  // set up firebase notification handle
  
  //  socket
  List<ChatUserModel> chatUsers = [];
  bool _loading = true;
  String userId = Get.find<AuthController>().getUserInfo()?.id ?? "";

  Future<void> refetch() async {
    var res = await room_service.getRoom(refetch: true);
    setState(() {
      chatUsers = res;
    });
  }

  void initSocket() async {
    await socketService.connectToSocket();
    socketService.onReceiveMessage((data) {
      if (data['userId'] != userInfo?.id) {
        audioPlayer.play(AssetSource('audios/livechat.mp3'));
      }

      refetch();
    });
  }

  @override
  void initState() {
    super.initState();
    initSocket();
    room_service.getRoom().then((value) {
      setState(() {
        chatUsers = value;
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => {context.push(RouteConst.search)}),
        title: GestureDetector(
          onTap: () => context.push(RouteConst.search),
          child: Text(
            'Tìm kiếm',
            style: GoogleFonts.getFont(primaryFont, fontSize: 18),
          ),
        ),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
        // centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.push(RouteConst.createChatRoom);
        },
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: chatUsers.isEmpty && _loading
              ? const Center(child: CircularProgressIndicator())
              : chatUsers.isEmpty
                  ? Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //   Image.asset(
                            //     'assets/images/welcome_image.png',
                            //     height: 200,
                            //   ),
                            const SizedBox(height: 30),
                            const Text(
                              'Chào mừng đến với ứng dụng chat',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Bắt đầu một cuộc trò chuyện mới, Zola có thể làm nhiều hơn là trò chuyện với bạn bè. Bạn có thể khám phá ngay',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                ),
                                child: const Text('Bắt đầu'),
                                onPressed: () {
                                  // Xử lý khi người dùng nhấn nút "Bắt đầu"
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: refetch,
                      child: ListView.builder(
                        itemCount: chatUsers.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        // physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ConversationItem(
                            id: chatUsers[index].id,
                            name: chatUsers[index].name,
                            messageText: chatUsers[index].messageText.isEmpty
                                ? "[${chatUsers[index].messageType}]"
                                : chatUsers[index].messageText,
                            sender: chatUsers[index].sender,
                            imageUrl: chatUsers[index].imageURL,
                            time: chatUsers[index].time,
                            isMessageRead:
                                (index == 0 || index == 3) ? true : false,
                            isGroup: chatUsers[index].isGroup,
                          );
                        },
                      ),
                    ),
        ),
      ]),
    );
  }
}
