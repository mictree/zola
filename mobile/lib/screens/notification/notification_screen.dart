import 'package:flutter/material.dart';
import 'package:zola/models/notification_model.dart';
import 'package:zola/utils/datetime_formater.dart';
import 'package:zola/widgets/notification_item.dart';
import 'package:zola/services/notification.dart' as notification_service;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> _notifications = [];
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  bool _isLoading = true;
  bool _isLoadingMore = false;

  Future<List<NotificationModel>> getNotification({bool isNew = false}) async {
    if (isNew) {
      page = 1;
    }
    return notification_service.getNotification(page: page);
  }

  void deleteFromState(String id) {
    setState(() {
      _notifications.removeWhere((notification) => notification.id == id);
    });
  }

  void loadMore() async {
    page++;
    setState(() {
      _isLoadingMore = true;
    });
    List<NotificationModel> moreNotifications =
        await notification_service.getNotification(page: page);
    setState(() {
      _notifications.addAll(moreNotifications);
    });
    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshNotifications() async {
    var notifications = await getNotification(isNew: true);
    setState(() {
      _notifications = notifications;
    });
  }

  @override
  void initState() {
    super.initState();
    getNotification().then((notifications) {
      setState(() {
        _notifications = notifications;
		_isLoading = false;
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Đánh dấu đã đọc tất cả"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Xóa tất cả thông báo"),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 0) {
                await notification_service.readAllNotification();
                _refreshNotifications();
              } else if (value == 1) {
                await notification_service.deleteAllNotification();
                _refreshNotifications();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollController,
                itemCount: _notifications.length,
                itemBuilder: (context, index) {

				  if (_isLoadingMore && index == _notifications.length - 1) {
					return const Center(
					  child: Padding(
						padding: EdgeInsets.all(8.0),
						child: CircularProgressIndicator(),
					  ),
					);
				  }

                  var data = _notifications[index];
                  return NotificationItem(
                    id: data.id,
                    postId: data.postId,
                    title: data.message,
                    subtitle: data.content,
                    time: DateTimeFormatterHelper.timeDifference(
                      data.createdAt.toString(),
                    ),
                    avatarUrl: data.avatarUrl,
                    isRead: data.isRead,
                    deleteNotification: () {
                      deleteFromState(data.id);
                    },
                  );
                },
              ),
      ),
    );
  }
}
