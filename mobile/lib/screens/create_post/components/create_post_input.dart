import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/controller/auth_controller.dart';
import 'package:zola/models/user_info_model.dart';
import 'package:zola/theme.dart';

class CreatePostInput extends StatelessWidget {
  UserProfileInfoModel? userInfo = Get.find<AuthController>().getUserInfo();
  CreatePostInput({Key? key}) : super(key: key);
  final String avatarUrl = Get.find<AuthController>().user!.avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: GestureDetector(
          onTap: () => context.push(RouteConst.createPost),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Flex(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            avatarUrl != "" && avatarUrl != "null"
                                ? NetworkImage(avatarUrl)
                                : const AssetImage("assets/images/avatar.png")
                                    as ImageProvider,
                        radius: 20,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        //add border radius here
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width * 0.7,
                        // add border
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "Hôm nay bạn thế nào?",
                          style: GoogleFonts.getFont(primaryFont, fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ));
  }
}
