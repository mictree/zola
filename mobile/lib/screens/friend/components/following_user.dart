import 'package:flutter/material.dart';
import 'package:zola/models/user_model_following.dart';
import 'package:zola/widgets/user_follow_widget.dart';

import 'package:zola/services/users.dart' as userService;

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List<UserFollowingModel> following = [];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    userService.getFollowing().then((value) {
      setState(() {
        following = value;
        _loading = false;
      });
    });

    userService.getFollowing(refetch: true).then((value) {
      setState(() {
        following = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : following.isEmpty
            ? const Center(child: Text('Không có dữ liệu'))
            : ListView.builder(
                itemCount: following.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: UserFollowingWidget(
                      id: following[index].id,
                      username: following[index].username,
                      name: following[index].fullname,
                      avatarUrl: following[index].avatarUrl,
                      bio: following[index].bio,
                      isFollowing: true,
                    ),
                  );
                },
              );
  }
}
