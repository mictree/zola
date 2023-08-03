import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/controller/auth_controller.dart';
import 'package:zola/controller/post_user_controller.dart';
import 'package:zola/controller/post_user_liked_controller.dart';
import 'package:zola/models/user_info_model.dart';
import 'package:zola/screens/profile/components/list_liked_post_user.dart';
import 'package:zola/screens/profile/components/user_info.dart';
import 'package:go_router/go_router.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/services/users.dart' as user_service;
import 'package:zola/services/post.dart' as post_service;
import 'package:zola/widgets/post_infinite_load.dart';

import '../list_post_user.dart';

class UserOverviewScreen extends StatefulWidget {
  String username;
  UserOverviewScreen({required this.username, super.key});

  @override
  State<UserOverviewScreen> createState() => _UserOverviewScreenState();
}

class _UserOverviewScreenState extends State<UserOverviewScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final controller = Get.put(PostUserController());
  final likedPostController = Get.put(PostUserLikedController());
  late TabController _tabController;
  int _currentIndex = 0;

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if(_currentIndex == 0) {
        controller.loadMore();
      }
	  else {
		likedPostController.loadMore();
	  }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: GestureDetector(
          onTap: () => context.push(RouteConst.search),
          child: Text(
            'Tìm kiếm',
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Iconsax.more),
            onPressed: () {
              // show bottom sheet
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return SizedBox(
                      height: 120,
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 20,
                            child: Divider(thickness: 5),
                          ),
                          const Center(
                            child: Text('Tuỳ chọn',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Iconsax.user,
                              color: Colors.blue,
                            ),
                            title: const Text('Sửa thông tin cá nhân',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            onTap: () {
                              context.pop();
                              context.push(RouteConst.updateProfile);
                            },
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: user_service.getUserInfo(widget.username == 'me'
              ? Get.find<AuthController>().user?.username ?? ''
              : widget.username, refetch: true),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    UserInfoOverview(
                      userInfoModel: UserProfileInfoModel(
                          id: snapshot.data['data']['_id'],
                          fullname: snapshot.data['data']['fullname'],
                          avatarUrl: snapshot.data['data']['avatarUrl'] ?? "",
                          username: snapshot.data['data']['username'],
                          coverUrl: snapshot.data['data']['coverUrl'] ?? "",
                          follower: snapshot.data['metadata']['follower'],
                          following: snapshot.data['metadata']['following'],
                          bio: snapshot.data['data']['contact_info']['bio'] ?? "",
                          isFollowing: snapshot.data['metadata']['isFollowing'] ?? "",
                          isMe: snapshot.data['metadata']['isMe'],
                          createdAt: snapshot.data['data']['created_date']),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const Divider(
                      height: 0,
                      thickness: 0,
                    ),
                    TabBar(
                      labelColor: Colors.black,
                      labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      unselectedLabelStyle:
                          const TextStyle(color: Colors.black),
                      isScrollable: true,
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 56.0),
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Bài viết'),
                        Tab(text: 'Đã thích'),
                      ],
                      onTap: (value) {
                        setState(() {
                          _currentIndex = value;
                        });
                      },
                    ),
                    _currentIndex == 0
                        ? const ListPostUser()
                        : const ListPostUserLiked(),
                    // const

                    // IndexedStack(
                    //   index: _currentIndex,
                    //   children: [
                    //     const ListPostUser(),
                    //     const ListPostUserLiked(),
                    //   ],
                    // )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
