import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zola/services/room.dart' as roomService;
import 'package:zola/constants.dart' as constants;
import 'package:zola/utils/secure_storage_helper.dart';

class SocketService extends GetxService {
  late IO.Socket socket;

  Future<void> connectToSocket() async {
    debugPrint('Connecting to Socket ...');

    var username = await FlutterSecureStorageHelper.getUsername();
    var userId = await FlutterSecureStorageHelper.getUserId();

    var url = kIsWeb ? 'http://localhost:5000' : constants.apiSocket;
    // var url = constants.localSocket;
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {'id': userId}
    });

    socket.connect();

    socket.onConnect((_) {
      debugPrint('Socket connected');
    });

    // join room
    List<String> rooms = await roomService.getAllRoomId();
    socket.emit('join_room', {'username': username, 'rooms': rooms});
  }

  void disconnect() {
    socket.disconnect();
  }

  // Gửi tin nhắn tới server gồm roomId và message content, message type
  void sendMessage(dynamic data) {
    print("send mess");
    socket.emit('send_message', data);
  }

  // Xử lý sự kiện nhận tin nhắn từ server
  void onReceiveMessage(Function(dynamic) callback) {
    socket.on('receive_message', (data) {
      callback(data);
    });
  }

  void onTyping(dynamic data) {
    socket.emit('typing', data);
  }

  // Xử lý sự kiện nhận typing từ server trả về roomId và username
  void onReceiveTyping(Function(dynamic) callback) {
    socket.on('typing', (data) {
      callback(data);
    });
  }

  void onStopTyping(dynamic data) {
    socket.emit('stop_typing', data);
  }

  void onReceiveStopTyping(Function(dynamic) callback) {
    socket.on('stop_typing', (data) {
      callback(data);
    });
  }

  void onReceiveNotification(Function(dynamic) callback) {
    socket.on('new_notification', (data) {
      data = data['data'];
      callback(data);
    });
  }
}
