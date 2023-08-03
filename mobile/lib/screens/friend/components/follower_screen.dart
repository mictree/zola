import 'package:flutter/material.dart';
import 'package:zola/models/user_model_following.dart';
import 'package:zola/widgets/user_follow_widget.dart';
import 'package:zola/services/users.dart' as userService;

class FollowerScreen extends StatefulWidget {
  const FollowerScreen({super.key});

  @override
  State<FollowerScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  List<UserFollowingModel> follower = [];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userService.getFollower().then((value) {
      setState(() {
        follower = value;
        _loading = false;
      });
    });

    userService.getFollower(refetch: true).then((value) {
      setState(() {
        follower = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return follower.isEmpty && _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : follower.isEmpty && !_loading
            ? const Center(
                child: Text('Chưa có ai theo dõi bạn cả'),
              )
            : ListView.builder(
                itemCount: follower.length,
                itemBuilder: (context, index) {
                  return UserFollowingWidget(
                    id: follower[index].id,
                    username: follower[index].username,
                    name: follower[index].fullname,
                    avatarUrl: follower[index].avatarUrl,
                    bio: follower[index].bio,
                    isFollowing: follower[index].isFollowing,
                  );
                },
              );
  }
}
