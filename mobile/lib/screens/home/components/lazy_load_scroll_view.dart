import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:uuid/uuid.dart';
import 'package:zola/controller/post_diary_controller.dart';
import 'package:zola/widgets/post_item.dart';

class LazyLoadWidget extends StatelessWidget {
  LazyLoadWidget({Key? key}) : super(key: key);

//   @override
  final controller = Get.put(PostDiaryController());

  @override
  Widget build(BuildContext context) {
    final outerScrollController = PrimaryScrollController.of(context);

    outerScrollController.addListener(() {
      if (outerScrollController.offset >=
          outerScrollController.position.maxScrollExtent - 100) {
        // trigger load next page
      }
    });
    // super.build(context);
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        height: 0,
        thickness: 1,
      ),
      controller: null,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: controller.posts.length,
      itemBuilder: (context, index) {
        final post = controller.posts[index];
        return PostItem(
          key: Key(Uuid().v4()),
          id: post.id,
          postTime: post.createAt,
          postContent: post.content,
          voteCount: post.totalLike,
          author: post.author,
          images: post.imgUrl,
          videoUrl: post.videoUrl,
          isLike: post.isLiked,
          totalComments: post.totalComment,
          onLike: () => controller.likePost(post.id),
        );
      },
    );
  }
}
