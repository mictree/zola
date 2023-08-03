import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/widgets/group_avatar.dart';

class ChatDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  String id;
  String imageUrl;
  String name;
  String status;
  bool isGroup;

  ChatDetailAppBar(
      {Key? key,
      this.imageUrl =
          "https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_1280.png",
      required this.id,
      required this.name,
      required this.isGroup,
      this.status = "online"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  Iconsax.arrow_left_2,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              isGroup
                  ? GroupAvatar(
                      imageUrl: imageUrl,
                      name: name.length > 10
                          ? "${name.substring(0, 10)}..."
                          : name,
                      radius: 20.0,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl.toString()),
                      maxRadius: 20,
                    ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      name.length > 10 ? "${name.substring(0, 10)}..." : name,
                      style: GoogleFonts.notoSans(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF44B513),
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 2),
                              ),
                            )),
                        Text(
                          status.toString(),
                          style: GoogleFonts.notoSans(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 32,
              ),
              isGroup
                  ? Container()
                  : InkWell(
                      onTap: () {
                        // show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Tín năng chưa phát triển"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Icon(
                        Iconsax.call,
                        color: Colors.black54,
                      ),
                    ),
              const SizedBox(
                width: 32,
              ),
              isGroup
                  ? Container()
                  : InkWell(
                      onTap: () {
                        // show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Tín năng chưa phát triển"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Icon(
                        Iconsax.video,
                        color: Colors.black54,
                      ),
                    ),
              const SizedBox(
                width: 30,
              ),
              IconButton(
                icon: const Icon(
                  Iconsax.menu,
                  color: Colors.black54,
                ),
                onPressed: () {
                  context.push(RouteConst.chatInfo.replaceFirst(":id", id));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60.0);
}
