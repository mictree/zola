import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zola/models/user_model_following.dart';
import 'package:zola/services/users.dart' as user_service;
import 'package:zola/widgets/user_follow_widget.dart';

class RecommenderScreen extends StatefulWidget {
  const RecommenderScreen({super.key});

  @override
  State<RecommenderScreen> createState() => _RecommenderScreenState();
}

class _RecommenderScreenState extends State<RecommenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gợi ý theo dõi'),
        // add back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder(
        future: user_service.getRecommendedUser(refetch: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Không có gợi ý theo dõi'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return UserFollowingWidget(
                    id: snapshot.data![index].id,
                    username: snapshot.data![index].username,
                    name: snapshot.data![index].fullname,
                    avatarUrl: snapshot.data![index].avatarUrl,
                    bio: snapshot.data![index].bio,
                    isFollowing: snapshot.data![index].isFollowing,
                  );
                });
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Đã xảy ra lỗi'),
            );
          }
          return const Center(
            child: Text('Đã xảy ra lỗi'),
          );
        },
      ),
    );
  }
}
