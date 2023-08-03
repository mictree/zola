import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:zola/models/post_model.dart';
import 'package:zola/widgets/hashtag_widget.dart';
import 'package:zola/widgets/post_item.dart';
import 'package:zola/services/post.dart' as post_service;
import 'package:zola/services/hashtag.dart' as hashtag_service;

class SearchPost extends StatefulWidget {
  String searchText;
  String filter;
  SearchPost({required this.searchText, required this.filter, super.key});

  @override
  State<SearchPost> createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost> {
  late Future<List<PostModel>> _futurePost;
  List<HashtagWidget> _trendyHashtag = [];

  Future<List<PostModel>> fetchPost() async {
    return await post_service.searchPost(1, widget.searchText, widget.filter);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futurePost = fetchPost();
    hashtag_service.getTrendyHashtag().then((value) {
      var data = value;
      for (var i = 0; i < data.length; i++) {
        _trendyHashtag.add(
            HashtagWidget(name: data[i]['hashtag'], count: data[i]['count']));
      }
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant SearchPost oldWidget) {
    _futurePost = fetchPost();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Chủ đề nổi bật',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
          ),
          Wrap(
            spacing: 12.0,
			runSpacing: 12.0,
            children: _trendyHashtag,
          ),
          const SizedBox(height: 20.0),
          FutureBuilder(
              future: _futurePost,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data![index];
                        return PostItem(
                            id: data.id,
                            postTime: data.createAt,
                            postContent: data.content,
                            voteCount: data.totalLike,
                            isLike: data.isLiked,
                            author: data.author,
                            videoUrl: data.videoUrl!,
                            images: data.imgUrl!,
                            totalComments: data.totalComment,
                            onLike: () {
                              setState(() {
                                data.isLiked = !data.isLiked;
                                if (data.isLiked) {
                                  data.totalLike++;
                                } else {
                                  data.totalLike--;
                                }
                              });
                            });
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Không tìm thấy bài viết phù hợp'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()));
                }

                return const Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()));
              }),
        ],
      ),
    );
  }
}
