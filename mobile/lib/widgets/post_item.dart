import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:zola/controller/auth_controller.dart';
import 'package:zola/models/user_info_model.dart';
import 'package:zola/theme.dart';
import 'package:zola/utils/datetime_formater.dart';
import 'package:zola/widgets/image_slider.dart';
import 'package:zola/widgets/comment_bottom_sheet.dart';
import 'package:zola/widgets/favorite_button.dart';
import 'package:zola/widgets/richtext_item.dart';
import 'package:zola/widgets/simple_video_player.dart';
import 'package:zola/utils/secure_storage_helper.dart';
import '../constants/route.dart';

class PostItem extends StatelessWidget {
  final String id;
  final String postTime;
  final UserProfileInfoModel author;
  final String postContent;
  final int voteCount;
  final List<String>? images;
  final String? videoUrl;
  final bool isLike;
  final int totalComments;
  Function onLike;
  final bool isDisableCommentSheet;

  PostItem({
    super.key,
    required this.id,
    required this.postTime,
    required this.postContent,
    required this.voteCount,
    this.images,
    this.videoUrl,
    required this.isLike,
    this.totalComments = 0,
    required this.author,
    required this.onLike,
    this.isDisableCommentSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // if in post detail screen, do nothing
          if (!isDisableCommentSheet) {
            context.push(RouteConst.postDetail.replaceAll(':id', id));
          }
        },
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: postContent));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    var myUsername =
                        await FlutterSecureStorageHelper.getUsername();
                    print(myUsername);
                    if (myUsername == author.username && context.mounted) {
                      context.push(RouteConst.profileOverview
                          .replaceAll(':username', 'me'));
                    } else if (context.mounted) {
                      context.push(RouteConst.userDetail
                          .replaceAll(':id', author.username));
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(author.avatarUrl),
                    radius: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        author.fullname.length > 20
                            ? '${author.fullname.substring(0, 20)}...'
                            : author.fullname,
                        style: GoogleFonts.getFont(primaryFont,
                            fontWeight: FontWeight.w600, fontSize: 18)),
                    Text(DateTimeFormatterHelper.timeDifference(postTime),
                        style: GoogleFonts.getFont(primaryFont,
                            fontWeight: FontWeight.w300, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                Container(
                    padding: const EdgeInsets.all(0.8),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator:
                                true, // root navigator is the parent navigator
                            constraints: BoxConstraints(
                                maxHeight: authController.user!.username ==
                                        author.username
                                    ? 250
                                    : 300),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0)),
                            ),
                            builder: (context) {
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  const SizedBox(
                                    width: 50.0,
                                    child: Divider(
                                      thickness: 5,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    leading: const Icon(Iconsax.eye_slash1),
                                    title: const Text('Xem chi tiết bài viết'),
                                    onTap: () {
                                      print(id);
                                      context.push(RouteConst.postDetail
                                          .replaceAll(':id', id));
                                    },
                                  ),
                                  authController.user!.username !=
                                          author.username
                                      ? Column(children: [
                                          ListTile(
                                            leading:
                                                const Icon(Iconsax.user_add),
                                            title: const Text(
                                                'Theo dõi người dùng'),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Iconsax.user_remove),
                                            title:
                                                const Text('Bỏ dõi người dùng'),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ])
                                      : const SizedBox(),
                                  ListTile(
                                    leading: const Icon(Iconsax.close_circle),
                                    title: const Text('Ẩn bài viết'),
                                    onTap: () {},
                                  ),
                                  authController.user!.username ==
                                          author.username
                                      ? ListTile(
                                          leading: const Icon(Iconsax.trash),
                                          title: const Text('Xóa bài viết'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Xác nhận xóa bài viết'),
                                                    content: const Text(
                                                        'Bạn có chắc chắn muốn xóa bài viết này?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Hủy'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Xóa'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        )
                                      : const SizedBox(),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Iconsax.more,
                            color: Colors.grey, size: 20))),
              ],
            ),
            const SizedBox(height: 8),
            RichTextItem(
              text: postContent,
              fontSize: 18,
            ),
            const SizedBox(height: 8),
            if (images != null && images!.isNotEmpty)
              if (images!.length == 1)
                GestureDetector(
                  onTap: () =>
                      context.push('/image-view?initialIndex=0', extra: images),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: CachedNetworkImage(
                        imageUrl: images![0],
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) => Container(
                            width: double.infinity,
                            height: 200,
                            // add box decoration to make it look like a placeholder
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.error)),
                      ),
                    ),
                  ),
                )
              else if (images!.length > 1)
                ImageSlider(imageUrls: images!),
            if (videoUrl!.isNotEmpty && images!.isEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                constraints: const BoxConstraints(
                  maxHeight: 300,
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    SimpleVideoPlayer(videoUrl: videoUrl!),
                    const Spacer(),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            isDisableCommentSheet
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FavoriteButton(
                            isFavorite: isLike,
                            id: 'p_$id',
                            onLike: onLike,
                          ),
                          Text(voteCount.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    useRootNavigator:
                                        true, // root navigator is the parent navigator
                                    constraints: BoxConstraints(
                                        minHeight:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.9),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(2.0),
                                        topRight: Radius.circular(2.0),
                                      ),
                                    ),
                                    builder: (BuildContext context) =>
                                        // CommentPage(),
                                        CommentBottomSheet(id: id),
                                  );
                                },
                                icon: const Icon(Iconsax.message),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      totalComments.toString(),
                                      style: GoogleFonts.notoSans(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8.0),
                          IconButton(
                            onPressed: () => {},
                            icon: const Icon(Iconsax.share),
                          ),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
