import 'package:flutter/material.dart';
import 'package:zola/models/post_model.dart';
import 'package:zola/models/user_info_model.dart';
import 'package:zola/screens/profile/components/user_info.dart';
import 'package:zola/services/users.dart' as user_service;
import 'package:zola/services/post.dart' as post_service;
import 'package:zola/widgets/post_item.dart';
import 'package:zola/widgets/post_item_skeleton.dart';

class UserDetailScreen extends StatefulWidget {
  String username;
  UserDetailScreen({required this.username, super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  List<PostModel> posts = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });
    var data = await post_service.getUserPost(_page, widget.username);
    if (data.isEmpty) {
      setState(() {
        _hasMore = false;
      });
    } else {
      setState(() {
        posts.addAll(data);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.extentAfter == 0) {
      // if no more data return
      if (!_hasMore) {
        return false;
      }
      if (!_isLoading) {
        _page++;
        fetchData();
      }
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin người dùng"),
      ),
      body: FutureBuilder(
        future: user_service.getUserInfo(widget.username),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data['data'].length == 0) {
            return const Center(
              child: Text("Chưa có dữ liệu"),
            );
          }

          if (snapshot.hasData) {
            return NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: SingleChildScrollView(
                child: Column(children: [
                  UserInfoOverview(
                    userInfoModel: UserProfileInfoModel(
                        id: snapshot.data['data']['_id'],
                        fullname: snapshot.data['data']['fullname'],
                        avatarUrl: snapshot.data['data']['avatarUrl'] ??
                            "https://picsum.photos/200/300",
                        username: snapshot.data['data']['username'],
                        coverUrl: snapshot.data['data']['coverUrl'] ??
                            "https://picsum.photos/200/300",
                        follower: snapshot.data['metadata']['follower'],
                        following: snapshot.data['metadata']['following'],
                        bio: snapshot.data['data']['contact_info']['bio'] ?? "",
                        isFollowing: snapshot.data['metadata']['isFollowing'],
                        isMe: snapshot.data['metadata']['isMe'],
                        createdAt: snapshot.data['data']['created_date']),
                  ),
                  const SizedBox(height: 36),
                  const Divider(
                    height: 0,
                    thickness: 0,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == posts.length) {
                        if (_isLoading) {
                          return const Center(
                            child: PostSkeletonLoading(),
                          );
                        }
                        return Container();
                      } else {
                        final post = posts[index];
                        return PostItem(
                          id: post.id,
                          postTime: post.createAt,
                          postContent: post.content,
                          voteCount: post.totalLike,
                          author: post.author,
                          images: post.imgUrl,
                          videoUrl: post.videoUrl,
                          isLike: post.isLiked,
                          totalComments: post.totalComment,
                          onLike: () {
                            setState(() {
                              post.isLiked = !post.isLiked;
                              if (post.isLiked) {
                                post.totalLike++;
                              } else {
                                post.totalLike--;
                              }
                            });
                          },
                        );
                      }
                    },
                  ),
                ]),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
