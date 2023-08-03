import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/services/notification.dart' as notificationService;

class NotificationItem extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String avatarUrl;
  final String time;
  final String postId;
  bool isRead;
  Function deleteNotification;

  NotificationItem(
      {super.key,
      required this.id,
      required this.title,
      required this.subtitle,
      required this.avatarUrl,
      required this.time,
      required this.postId,
      required this.isRead,
      required this.deleteNotification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isRead ? Colors.white : Colors.blue[50],
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(avatarUrl),
      ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle,
                maxLines: 2,
              )),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              time,
              style: GoogleFonts.notoSans(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              builder: (BuildContext context) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: const Text('Xóa thông báo'),
                        onTap: () async {
                          // Perform delete action
                          Navigator.pop(context);
                          await notificationService.deleteNotification(id);
                          deleteNotification();
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.notifications_off),
                        title: const Text('Tắt thông báo người dùng này'),
                        onTap: () {
                          // Perform turn off notifications action
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }),
      onTap: () async {
        context.push(RouteConst.postDetail.replaceAll(':id', postId));
        await notificationService.readNotification(id);
        await deleteNotification();
      },
    );
  }
}
