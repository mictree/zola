import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/screens/friend/components/contact_screen.dart';
import 'package:zola/screens/friend/components/follower_screen.dart';
import 'package:zola/screens/friend/components/following_user.dart';
import 'package:zola/screens/friend/components/group_screen.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _tabController = TabController(length: 4, vsync: this);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  TabBar get _tabBar => TabBar(
        labelColor: Colors.black,
        labelStyle: GoogleFonts.notoSans(color: Colors.black),
        unselectedLabelStyle: GoogleFonts.notoSans(color: Colors.black),
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 56.0),
        controller: _tabController,
        tabs: [
          Tab(text: 'Bạn bè'.toUpperCase()),
          Tab(text: 'Nhóm'.toUpperCase()),
          Tab(text: 'Đang theo dõi'.toUpperCase()),
          Tab(text: 'Người theo dõi'.toUpperCase()),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
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
          leading:
              IconButton(icon: const Icon(Icons.search), onPressed: () => {}),
          title: GestureDetector(
            onTap: () {
              context.push(RouteConst.search);
            },
            child: Text(
              'Tìm kiếm',
              style: GoogleFonts.notoSans(fontSize: 18),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => context.push('/user-recommend'),
              icon: const Icon(Iconsax.user_add),
            )
          ],
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: Material(
              color: Colors.white,
              child: _tabBar,
            ),
          ),
        //   centerTitle: true,
        ),
        body: TabBarView(
            physics: const BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            controller: _tabController,
            children: const <Widget>[
              ContactScreen(),
              GroupScreen(),
              FollowingScreen(),
              FollowerScreen()
            ]),
      ),
    );
  }
}
