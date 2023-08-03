import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/controller/post_diary_controller.dart';
import 'package:zola/controller/post_recommend_controller.dart';
import 'package:zola/screens/create_post/components/create_post_input.dart';
import 'package:zola/screens/home/components/list_post.dart';
import 'package:flutter/material.dart';

import 'recommend_post.dart';

class DiaryBody extends StatefulWidget {
  const DiaryBody({Key? key}) : super(key: key);

  @override
  State<DiaryBody> createState() => _DiaryBodyState();
}

class _DiaryBodyState extends State<DiaryBody> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _innerScrollController = ScrollController();
  final controller = Get.put(PostDiaryController());
  final recommendController = Get.put(PostRecommendController());

  String dropdownValue = 'Đang theo dõi';
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Do something when ListView reaches the bottom
      print('ListView reached the bottom');
      controller.loadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _innerScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    _innerScrollController.removeListener(_scrollListener);
    _innerScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        if (dropdownValue == 'Đang theo dõi') {
          await controller.refetch();
        } else {
          await recommendController.refetch();
        }
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            CreatePostInput(),
            // const NewFeed(),
            Container(
              height: 10,
              color: Colors.white,
            ),
            const Divider(
              thickness: 1,
              height: 0,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              width: double.infinity,
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Iconsax.arrow_down_2),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Đang theo dõi', 'Gợi ý']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Chọn'),
              ),
            ),
			const SizedBox(height: 10,),
            Container(
              color: Colors.white,
              child: dropdownValue == 'Đang theo dõi'
                  ? ListPost(
                      scrollController: _innerScrollController,
                    )
                  : const RecommendPostList(),
            )
          ],
        ),
      ),
    );
  }
}
