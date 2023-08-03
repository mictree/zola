import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/controller/auth_controller.dart';
import 'package:zola/screens/profile/components/profile_body.dart';
import 'package:go_router/go_router.dart';
import 'package:zola/theme.dart';
import 'package:zola/constants/route.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onTap: () => context.push(RouteConst.search),
          child: Text(
            'Tìm kiếm',
            style: GoogleFonts.getFont(primaryFont, fontSize: 18),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              //   icon: const Icon(Iconsax.setting2),
              icon: const Icon(Icons.settings),
              itemBuilder: (_) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Đăng xuất"),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  try {
                    await Get.find<AuthController>().logout();
                    if (context.mounted) context.go(RouteConst.login);
                  } catch (e) {
                    print(e);
                  }
                }
              }),
        ],
      ),
      body: ProfileBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          const Icon(Iconsax.search_normal_1, size: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text('Tìm kiếm', style: GoogleFonts.notoSans(fontSize: 14)),
          )
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Iconsax.setting_2),
          onPressed: () {
            print('Login in profile');
          },
        ),
      ],
    );
  }
}
