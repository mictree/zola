import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/models/comment_model.dart';
import 'package:zola/widgets/comment_item.dart';

import 'package:zola/services/comment.dart' as comment_service;

class CommentBottomSheet extends StatefulWidget {
  final String id;
  const CommentBottomSheet({super.key, required this.id});

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  late Future<List<CommentModel>> commentList;
  TextEditingController textEditingController = TextEditingController();
  late FocusNode textFocusNode;
  bool _isCommenting = false;
  String parentId = "";
  String replyTo = "";

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
    refreshData();
    textEditingController.clear();
    //unfocus keyboard
    FocusManager.instance.primaryFocus?.unfocus();
  }

  refreshData() {
    comment_service.getCommentFromPost(widget.id).then((value) => setState(() {
          commentList = Future.value(value);
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    commentList = comment_service.getCommentFromPost(widget.id);
    super.initState();
    textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          direction: Axis.vertical,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bình luận",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Iconsax.close_square)),
                ],
              ),
            ),
            FutureBuilder(
                future: commentList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        padding: const EdgeInsets.all(16),
                        child: snapshot.data!.isEmpty
                            ? const Center(
                                child: Text("Chưa có bình luận nào cả"))
                            : ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  void onReply(String username) {
                                    textFocusNode.requestFocus();
                                    textEditingController.text =
                                        "@$username ";
                                    parentId = snapshot.data![index].id;
                                    replyTo = snapshot.data![index].id;
                                    // move cursor to end of text
                                    textEditingController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: textEditingController
                                                .text.length));
                                  }

                                  return CommentWidget(
                                    id: snapshot.data![index].id,
                                    isFavorite: snapshot.data![index].isLiked,
                                    favoriteCount:
                                        snapshot.data![index].totalLike,
                                    avatarUrl: snapshot
                                        .data![index].author.avatarUrl
                                        .toString(),
                                    fullname:
                                        snapshot.data![index].author.fullname,
                                    username:
                                        snapshot.data![index].author.username,
                                    content: snapshot.data![index].content,
                                    timeAgo: snapshot.data![index].createdAt
                                        .toString(),
                                    replyCount: snapshot.data![index].totalRely,
                                    onDelete: () async {
                                      await comment_service.deleteComment(
                                          snapshot.data![index].id);
                                      setState(() {
                                        snapshot.data!.removeAt(index);
                                      });
                                    },
                                    onReply: () => onReply(
										snapshot.data![index].author.username),
                                  );
                                }),
                      ),
                    ));
                  } else {
                    return const Flexible(
                        child: Center(child: CircularProgressIndicator()));
                  }
                }),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  )),
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
          ]),
    );
  }
}
