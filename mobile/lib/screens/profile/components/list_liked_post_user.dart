import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zola/controller/post_user_liked_controller.dart';
import 'package:zola/widgets/post_item.dart';
import 'package:zola/widgets/post_item_skeleton.dart';

class ListPostUserLiked extends StatefulWidget {
  const ListPostUserLiked({Key? key}) : super(key: key);

  @override
  State<ListPostUserLiked> createState() => _ListPostUserLikedState();
}

class _ListPostUserLikedState extends State<ListPostUserLiked> {
  final controller = Get.put(PostUserLikedController());

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value && controller.posts.isEmpty) {
        return const Center(child: PostSkeletonLoading());
      } else if (controller.error.value && controller.posts.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error),
              SizedBox(height: 16),
              Text('Failed to load data. Please try again later.'),
            ],
          ),
        );
      } else {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: controller.posts.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.posts.length) {
              return Center(
                child: Visibility(
                  visible: controller.loading.value,
                  child: const Center(child: PostSkeletonLoading()),
                ),
              );
            } else {
              final post = controller.posts[index];
              return PostItem(
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
            }
          },
        );
      }
    });
  }
}
