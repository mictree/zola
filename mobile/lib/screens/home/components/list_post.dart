import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:zola/controller/post_diary_controller.dart';
import 'package:zola/widgets/post_item.dart';
import 'package:zola/widgets/post_item_skeleton.dart';

class ListPost extends StatelessWidget {
  ScrollController scrollController;

  ListPost({required this.scrollController, Key? key}) : super(key: key);

//   @override
  final controller = Get.put(PostDiaryController());

  @override
  Widget build(BuildContext context) {
    // super.build(context);
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
              Text('Có lỗi xảy ra, thử lại sau.'),
            ],
          ),
        );
      }
      if (controller.posts.isEmpty && !controller.loading.value) {
        return Container(
          // max height
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 12, 20.0, 8),
              child: Column(
                children: [
                  const Text('Chưa có bài viết nào.',
                      style: TextStyle(fontSize: 18.0)),
                  const Text(
                    'Hãy theo dõi các người dùng khác để xem bài viết của họ.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  ElevatedButton(
                    onPressed: () => context.push('/user-recommend'),
                    child: const Text('Gợi ý người dùng'),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
		  separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1,),
          controller: scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: controller.posts.length + 1,
		  cacheExtent: 50,
          itemBuilder: (context, index) {
            if (index == controller.posts.length) {
              return Visibility(
                visible: controller.loading.value,
                child: const Center(
                  child: Expanded(
                    child: PostSkeletonLoading(),
                  ),
                ),
              );
            } else {
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
            }
          },
        );
      }
    });
  }
}
