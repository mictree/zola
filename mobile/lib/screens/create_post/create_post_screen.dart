import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/controller/create_post_controller.dart';
import 'package:zola/theme.dart';
import 'components/create_post_body.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final postController = Get.put(CreatePostController());

  bool _isLoading = false;

  //List of post type
  final List<dynamic> postType = [
    {"icon": Iconsax.global, "title": "Công khai", "value": "public"},
    {"icon": Iconsax.user, "title": "Bạn bè", "value": "friend"},
    {"icon": Iconsax.lock, "title": "Chỉ mình tôi", "value": "private"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 50.0),
          child: GetBuilder<CreatePostController>(builder: (logic) {
            return buildAppBar(context);
          })),
      body: Center(
        child: Stack(
          children: [
            const CreatePostBody(),
            _isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  _showAlertDialog(String message, context) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Đóng hộp thoại khi người dùng chọn OK.
              },
            ),
          ],
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.blueAccent),
      title: InkWell(
        onTap: () => showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (context) => SizedBox(
                  height: 230,
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 50.0,
                        child: Divider(
                          thickness: 5,
                        ),
                      ),
                      Text(
                        "Chọn đối tượng",
                        style: GoogleFonts.getFont(primaryFont,
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      for (var item in postType)
                        ListTile(
                          leading: Icon(
                            item["icon"],
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            item["title"],
                            style: GoogleFonts.getFont(primaryFont,
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            postController.addScope(item["value"]);
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  ),
                )),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          direction: Axis.horizontal,
          children: [
            Icon(
              postType.singleWhere((element) =>
                  element["value"] == postController.scope)["icon"],
              size: 16,
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                postType.singleWhere((element) =>
                    element["value"] == postController.scope)["title"],
                style: GoogleFonts.getFont(primaryFont,
                    fontSize: 16, color: Colors.black),
              ),
            ),
            const Icon(
              Iconsax.arrow_down_1,
              size: 16,
              color: Colors.black,
            )
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Iconsax.send1,
            color: Colors.blueAccent,
          ),
          onPressed: _isLoading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    if (postController.content == "" &&
                        postController.images == null &&
                        postController.video == null) {
                      _showAlertDialog("Nội dung không được để trống", context);
                    }
                      await postController.createPost(context);
                    print('on tap');
                    setState(() {
                      _isLoading = false;
                    });
                    postController.clearAll();
                    if (context.mounted) {
                      _showAlertDialog("Đăng bài thành công", context);
                    }
                  } catch (e) {
                    print(e);
                    _showAlertDialog("Đăng bài thất bại", context);
                  }
                },
        ),
      ],
    );
  }
}
