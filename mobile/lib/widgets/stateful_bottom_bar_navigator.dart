import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zola/constants/route.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/theme.dart';

// ignore: must_be_immutable
class ScaffoldWithStatefulNavBar extends StatefulWidget {
  String location;
  ScaffoldWithStatefulNavBar(
      {super.key, required this.child, required this.location});

  final StatefulNavigationShell child;

  @override
  State<ScaffoldWithStatefulNavBar> createState() =>
      _ScaffoldWithStatefulNavBarState();
}

class _ScaffoldWithStatefulNavBarState
    extends State<ScaffoldWithStatefulNavBar> {
  static const List<MyCustomBottomNavBarItem> tabs = [
    MyCustomBottomNavBarItem(
      icon: Icon(Iconsax.home_14),
      activeIcon: Icon(Iconsax.home5),
      label: 'Trang chủ',
      initialLocation: RouteConst.diary,
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(Iconsax.document),
      activeIcon: Icon(Iconsax.document5),
      label: 'Danh bạ',
      initialLocation: RouteConst.friend,
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(Iconsax.message_text),
      activeIcon: Icon(Iconsax.message_text_15),
      label: 'Tin nhắn',
      initialLocation: RouteConst.chat,
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(Iconsax.profile_circle),
      activeIcon: Icon(Iconsax.profile_circle5),
      label: 'Cá nhân',
      initialLocation: RouteConst.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: widget.child),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedLabelStyle: blackTextStylePrimary,
        unselectedLabelStyle: blackTextStylePrimary,
        selectedItemColor: const Color(0xFF434343),
        selectedFontSize: 12,
        unselectedItemColor: const Color(0xFF838383),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _goOtherTab(index);
        },
        currentIndex: widget.child.currentIndex,
        items: tabs,
      ),
    );
  }

  void _goOtherTab(int index) {
    widget.child.goBranch(
      index,
      initialLocation: index == widget.child.currentIndex,
    );
  }

  int _getCurrentIndex(location) {
    switch (location) {
      case RouteConst.diary:
        return 0;
      case RouteConst.friend:
        return 1;
      case RouteConst.chat:
        return 2;
      default:
        return 3;
    }
  }
}

class MyCustomBottomNavBarItem extends BottomNavigationBarItem {
  final String initialLocation;

  const MyCustomBottomNavBarItem(
      {required this.initialLocation,
      required Widget icon,
      String? label,
      Widget? activeIcon})
      : super(icon: icon, label: label, activeIcon: activeIcon ?? icon);
}
