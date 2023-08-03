import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zola/controller/create_post_controller.dart';
import 'package:zola/theme.dart';
import 'package:zola/widgets/video_player_detail.dart';

class CreatePostBody extends StatefulWidget {
  const CreatePostBody({Key? key}) : super(key: key);

  @override
  State<CreatePostBody> createState() => _CreatePostBodyState();
}

class _CreatePostBodyState extends State<CreatePostBody> {
  final picker = ImagePicker();
  CreatePostController createPostController = Get.find<CreatePostController>();

  Future getImage() async {
    final pickedFile = await picker.pickMultiImage();

    if (pickedFile != null) {
      createPostController
          .addImages(pickedFile.map((e) => File(e.path)).toList());
      createPostController.video = null;
    } else {
      print('No image selected.');
    }
  }

  Future getVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      createPostController.addVideo(File(pickedFile.path));
      createPostController.images = null;
    } else {
      print('No video selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CreatePostController>(
        builder: (_) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   mainAxisSize: MainAxisSize.max,
          //   direction: Axis.vertical,
          children: [
            const Divider(
              thickness: 0,
              height: 0,
            ),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  createPostController.addContent(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Bạn đang nghĩ gì?',
                  contentPadding: EdgeInsets.all(8),
                  border: InputBorder.none,
                ),
                style: GoogleFonts.getFont(primaryFont, fontSize: 22),
                maxLines: null,
                expands: true,
              ),
            ),
            // const Divider(
            //   thickness: 0,
            //   height: 0,
            // ),
            const Spacer(),

            if (createPostController.images != null &&
                createPostController.images!.isNotEmpty)
              Stack(children: [
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: createPostController
                        .images!.length, // số lượng hình ảnh trong danh sách
                    itemBuilder: (context, index) {
                      if (kIsWeb) {
                        return Container(
                            child: Image.network(
                                createPostController.images![index].path));
                      } else {
                        return ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Image.file(
                              createPostController.images![index] as File),
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      createPostController.addImages([]);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ]),

            if (createPostController.video != null)
              Container(
                child: kIsWeb
                    ? Image.network(createPostController.video!.path)
                    : SizedBox(
                        height: 200,
                        child: VideoPlayerDetail(
                          videoUrl: createPostController.video!.path,
                          isShowController: false,
                        ),
                      ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Icon(Iconsax.emoji_normal)),
                    Row(
                      children: [
                        TextButton(
                            onPressed: getVideo,
                            child: const Icon(Iconsax.video)),
                        TextButton(
                            onPressed: getImage,
                            child: const Icon(Iconsax.gallery)),
                        TextButton(
                            onPressed: () {}, child: const Icon(Iconsax.link)),
                        TextButton(
                            onPressed: () {},
                            child: const Icon(Iconsax.location)),
                      ],
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
