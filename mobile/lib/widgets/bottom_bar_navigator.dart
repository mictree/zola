import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zola/constants/route.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/theme.dart';


// ignore: must_be_immutable
class ScaffoldWithNavBar extends StatefulWidget {
  String location;
  ScaffoldWithNavBar({super.key, required this.child, required this.location});

  final Widget child;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int _currentIndex = 0;
  static const List<MyCustomBottomNavBarItem> tabs = [
    MyCustomBottomNavBarItem(
      icon: Icon(Iconsax.home_14),
      activeIcon: Icon(Iconsax.home5),
      label: 'Nhật ký',
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
          _goOtherTab(context, index);
        },
        currentIndex: _getCurrentIndex(widget.location),
        items: tabs,
      ),
    );
  }

  void _goOtherTab(BuildContext context, int index) {
    if (index == _currentIndex) return;
    GoRouter router = GoRouter.of(context);
    String location = tabs[index].initialLocation;

    setState(() {
      _currentIndex = index;
    });
    if (index == 3) {
      // context.push('/login');
      router.go(location);
    } else {
      router.go(location);
    }
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
