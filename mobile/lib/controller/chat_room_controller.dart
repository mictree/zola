import 'package:get/get.dart';

import 'package:zola/models/chat_user_model.dart';
import 'package:zola/services/room.dart' as chatRoomService;

class ChatRoomController extends GetxController {
  List<ChatUserModel> chatUsers = [];

  @override
  void onInit() async {
    super.onInit();
    chatUsers = await chatRoomService.getRoom();
  }

  void refetch() async {
    chatUsers = await chatRoomService.getRoom();
    update();
  }

  void addChatUser(ChatUserModel chatUser) {
    chatUsers.add(chatUser);
    update();
  }
}
