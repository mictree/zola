import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:zola/models/message_model.dart';

class MessageController extends GetxController {
  IO.Socket socket;
  List<MessageModel> messages = [];

  MessageController(this.socket);

  @override
  void onInit() {
    super.onInit();

    socket.on('receive_message', (data) {
      messages.add(MessageModel.fromJson(data));
      update();
    });
  }

  void sendMessage(String message, String roomId) {
    socket.emit('send_message', {'message': message, 'roomId': roomId});
  }
}
