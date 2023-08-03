import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/models/comment_model.dart';
import 'package:zola/models/post_model.dart';
import 'package:zola/widgets/comment_item.dart';
import 'package:zola/widgets/favorite_button.dart';
import 'package:zola/widgets/post_item.dart';
import 'package:zola/widgets/post_item_skeleton.dart';
import 'package:zola/services/post.dart' as post_service;
import 'package:zola/services/comment.dart' as comment_service;

class PostDetailScreen extends StatefulWidget {
  final String id;

  const PostDetailScreen({super.key, required this.id});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  int totalLike = 0;
  late PostModel postModel;
  late Future<List<CommentModel>> commentList;
  TextEditingController textEditingController = TextEditingController();
  late FocusNode textFocusNode;
  bool _isCommenting = false;
  String parentId = "";
  String replyTo = "";
  final ScrollController _scrollController = ScrollController();

  _onComment() async {
    setState(() {
      _isCommenting = true;
    });
    if (parentId == "" && replyTo == "") {
      await comment_service.createComment(
          widget.id, textEditingController.text);
    } else {
      await comment_service.replyComment(
          widget.id, parentId, replyTo, textEditingController.text);
    }

    setState(() {
      _isCommenting = false;
    });
    refreshComment();
    textEditingController.clear();
    //unfocus keyboard
    FocusManager.instance.primaryFocus?.unfocus();
  }

  refreshComment() async {
    await comment_service
        .getCommentFromPost(widget.id)
        .then((value) => setState(() {
              commentList = Future.value(value);
            }));
  }

  @override
  void initState() {
    super.initState();
    post_service.getPostById(widget.id).then((value) => postModel = value);
    commentList = comment_service.getCommentFromPost(widget.id);
    textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài viết'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: FutureBuilder(
              future: post_service.getPostById(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data;

                  return Column(
                    children: [
                      PostItem(
                        id: widget.id,
                        postTime: data!.createAt,
                        postContent: data.content,
                        voteCount: data.totalLike,
                        images: data.imgUrl,
                        videoUrl: data.videoUrl,
                        isLike: data.isLiked,
                        author: data.author,
                        totalComments: data.totalComment,
                        isDisableCommentSheet: true,
                        onLike: () {
                          setState(() {
                            if (postModel.isLiked) {
                              postModel.totalLike -= 1;
                            } else {
                              postModel.totalLike += 1;
                            }
                          });
                          post_service.likeOrUnlikePost(widget.id);
                        },
                      ),

                      // Action bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        child: Row(
                          children: [
                            FavoriteButton(
                                id: data.id,
                                isFavorite: data.isLiked,
                                onLike: () {
                                  setState(() {
                                    if (postModel.isLiked) {
                                      postModel.totalLike -= 1;
                                    } else {
                                      postModel.totalLike += 1;
                                    }
                                  });
                                  post_service.likeOrUnlikePost(widget.id);
                                }),
                            const SizedBox(width: 10),
                            Text("${data.totalLike} lượt thích"),
                            const SizedBox(width: 10),
                            Text("${data.totalComment} bình luận"),
                            const Divider()
                          ],
                        ),
                      ),

                      FutureBuilder(
                          future: commentList,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () => FocusManager.instance.primaryFocus
                                    ?.unfocus(),
                                child: Container(
									height: MediaQuery.of(context).size.height * 0.6,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 32),
                                  child: snapshot.data!.isEmpty
                                      ? const Center(
                                          child: Text(
                                              "Chưa có bình luận nào cả"))
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          controller: _scrollController,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            return CommentWidget(
                                              id: snapshot.data![index].id,
                                              isFavorite:
                                                  snapshot.data![index].isLiked,
                                              favoriteCount: snapshot
                                                  .data![index].totalLike,
                                              avatarUrl: snapshot
                                                  .data![index].author.avatarUrl
                                                  .toString(),
                                              fullname: snapshot
                                                  .data![index].author.fullname,
                                              username: snapshot
                                                  .data![index].author.username,
                                              content:
                                                  snapshot.data![index].content,
                                              timeAgo: snapshot
                                                  .data![index].createdAt
                                                  .toString(),
                                              replyCount: snapshot
                                                  .data![index].totalRely,
												onDelete: ()async{
													await comment_service.deleteComment(snapshot.data![index].id);
													setState(() {
													  snapshot.data!.removeAt(index);
													});
												},
                                              onReply: () {
                                                textFocusNode.requestFocus();
                                                textEditingController.text =
                                                    "@${snapshot.data![index].author.username} ";
                                                parentId =
                                                    snapshot.data![index].id;
                                                replyTo =
                                                    snapshot.data![index].id;
                                              },
                                            );
                                          }),
                                ),
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    ],
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const PostSkeletonLoading();
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Lỗi"));
                }

                return const Center(child: Text("Không có bài viết"));
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Iconsax.emoji_normal),
                  Expanded(
                      child: TextField(
                    controller: textEditingController,
                    focusNode: textFocusNode,
                    decoration: const InputDecoration(
                      hintText: 'Nhập bình luận...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.getFont("Poppins", fontSize: 16),
                    maxLines: 10,
                    minLines: 1,
                  )),
                  const Icon(Iconsax.gallery),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.send1),
                    color: Colors.blueAccent,
                    onPressed: _isCommenting ? null : _onComment,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
