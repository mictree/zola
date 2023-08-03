import 'package:flutter/material.dart';
import 'package:zola/models/post_model.dart';
import 'package:zola/widgets/post_item.dart';
import 'package:zola/widgets/post_item_skeleton.dart';

class PostInfiniteLoadWidget extends StatefulWidget {
  String username;
  Function loadData;
  ScrollController scrollController;
  PostInfiniteLoadWidget(
      {required this.username,
      required this.loadData,
      required this.scrollController,
      super.key});

  @override
  State<PostInfiniteLoadWidget> createState() => _PostInfiniteLoadWidgetState();
}

class _PostInfiniteLoadWidgetState extends State<PostInfiniteLoadWidget> {
  List<PostModel> posts = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });
    var data = await widget.loadData(_page, widget.username);
    if (data.isEmpty) {
      setState(() {
        _hasMore = false;
      });
    } else {
      setState(() {
        posts.addAll(data);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _scrollListener() {
    if (widget.scrollController.offset >=
            widget.scrollController.position.maxScrollExtent &&
        !widget.scrollController.position.outOfRange) {
      print('ListView reached the bottom');
      if (!_hasMore) {
        return;
      }
      if (!_isLoading) {
        _page++;
        fetchData();
      }
      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.scrollController,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: posts.length + 1,
      itemBuilder: (context, index) {
        if (index == posts.length) {
          if (_isLoading) {
            return const Center(
              child: PostSkeletonLoading(),
            );
          }
          return Container();
        } else {
          final post = posts[index];
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
            onLike: () {
              setState(() {
                post.isLiked = !post.isLiked;
                if (post.isLiked) {
                  post.totalLike++;
                } else {
                  post.totalLike--;
                }
              });
            },
          );
        }
      },
    );
  }
}
