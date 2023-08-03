import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zola/screens/home/components/diary_body.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/theme.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/services/notification.dart' as notificationService;
import 'package:zola/services/socket_service.dart';
import 'package:get/get.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  int unreadNotification = 0;
  SocketService socketService = Get.find<SocketService>();

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'post') {
      context.push(RouteConst.postDetail.replaceAll(':id', message.data["id"]));
    } else if (message.data['type'] == 'message') {
      context.push(RouteConst.message.replaceAll(':id', message.data["id"]));
    }
  }

  void showSnackbar(String message, String type) {
    final snackBar = SnackBar(
      backgroundColor: Colors.lightBlueAccent,
      elevation: 5,
      behavior: SnackBarBehavior.fixed,
      content: GestureDetector(
        onTap: () {
          // Xử lý sự kiện khi người dùng bấm vào snackbar
          print('Snackbar được bấm');
        },
        child: Container(
          // add border radius to snackbar
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 2.0, color: Colors.teal),
              bottom: BorderSide(width: 2.0, color: Colors.teal),
              left: BorderSide(width: 2.0, color: Colors.teal),
              right: BorderSide(width: 2.0, color: Colors.teal),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.white,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(
                  type == "post" ? Iconsax.notification : Iconsax.message,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child:
                    Text(message, style: const TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
      //   action: SnackBarAction(
      //     label: 'OK',
      //     onPressed: () {
      //       // Xử lý sự kiện khi người dùng bấm vào snackbar
      //       print('Snackbar được bấm');
      //     },
      //   ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Init app handle
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      notificationService.countUnreadNotification().then((value) {
        setState(() {
          unreadNotification = value;
        });
      });
      if (message.data['type'] == 'post') {
        // showSnackbar(message.notification?.body ?? "", "post");
      } else if (message.data['type'] == 'message') {
        // showSnackbar(message.notification?.body ?? "", "message");
      }
    });

    FirebaseMessaging.instance.getToken().then((token) {
      print('Device Token FCM: $token');
    });
  }

  @override
  void initState() {
    super.initState();

    // check is socket service initialized
    socketService.connectToSocket().then((_) {
      socketService.onReceiveNotification((p0) {
        //show snack bar
        unreadNotification++;
        print("New notification");
      });
    });

    notificationService.countUnreadNotification().then((value) {
      setState(() {
        unreadNotification = value;
      });
    });

    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
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
            onPressed: () => context.push(RouteConst.search)),
        title: GestureDetector(
          onTap: () => context.push(RouteConst.search),
          child: Text(
            'Tìm kiếm',
            style: GoogleFonts.getFont(primaryFont, fontSize: 18),
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                icon: const Icon(Iconsax.edit),
                onPressed: () => context.push(RouteConst.createPost),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Iconsax.notification),
                    onPressed: () => context.push(RouteConst.notification),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        unreadNotification.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      // Add drop down menu to select following or recommend

      // floating button to scroll to top
      body: DiaryBody(),
    );
  }
}
