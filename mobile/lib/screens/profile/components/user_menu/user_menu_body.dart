import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/controller/auth_controller.dart';
import 'package:zola/theme.dart';

class UserMenuBody extends StatefulWidget {
  const UserMenuBody({super.key});

  @override
  State<UserMenuBody> createState() => _UserMenuBodyState();
}

class _UserMenuBodyState extends State<UserMenuBody> {
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        GestureDetector(
          onTap: () =>
              context.push(RouteConst.profileOverview.replaceAll(':username', 'me')),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: NetworkImage(
                              controller.getUserInfo()?.avatarUrl ?? ""),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100.0)),
                        border: Border.all(
                          color: Colors.white,
                          width: 4.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.getUserInfo()?.fullname ?? "",
                          style: GoogleFonts.getFont(primaryFont,
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Xem trang cá nhân",
                          style: GoogleFonts.getFont(primaryFont,
                              fontSize: 16, fontWeight: FontWeight.w300),
                        )
                      ],
                    )
                  ],
                ),
                const Icon(Iconsax.arrow_right_3)
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Iconsax.security_user),
                  const SizedBox(
                    width: 24,
                  ),
                  Text(
                    "Tài khoản và bảo mật",
                    style: GoogleFonts.getFont(primaryFont,
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Icon(Iconsax.arrow_right_3)
            ],
          ),
        ),
        const Divider(
          thickness: 0,
          height: 0,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Iconsax.lock),
                  const SizedBox(
                    width: 24,
                  ),
                  Text(
                    "Quyền riêng tư",
                    style: GoogleFonts.getFont(primaryFont,
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Icon(Iconsax.arrow_right_3)
            ],
          ),
        )
      ],
    );
  }
}
