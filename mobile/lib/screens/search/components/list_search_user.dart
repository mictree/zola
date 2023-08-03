import 'package:flutter/material.dart';
import 'package:zola/models/user_model_following.dart';
import 'package:zola/services/users.dart' as user_service;
import 'package:zola/widgets/user_follow_widget.dart';

class ListSearchUser extends StatefulWidget {
  String searchText;
  ListSearchUser({required this.searchText, super.key});

  @override
  State<ListSearchUser> createState() => _ListSearchUserState();
}

class _ListSearchUserState extends State<ListSearchUser> {
  List<UserFollowingModel> _data = [];
  bool _isLoading = false;

//   void _loadMore() async {
//     if (_isLoading) return;
//     setState(() {
//       _isLoading = true;
//     });
//     _page++;
//     final newData = userService.searchUser(widget.searchText);
//     setState(() {
//       _data.add(newData as UserFollowingModel);
//     });
//   }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    var newData = await user_service.searchUser(widget.searchText);
    setState(() {
      _data = newData;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ListSearchUser oldWidget) {
    _fetchData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _data.isEmpty && !_isLoading
          ? const Center(child: Text('Không tìm thấy người dùng nào'))
          : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _data.length,
                  shrinkWrap: true,
                  //   + (_isLoading ? 1 : 0)
                  itemBuilder: (context, index) {
                    // if (index == _data.length) {
                    //   return const Center(child: CircularProgressIndicator());
                    // }
                    var current = _data[index];
                    return UserFollowingWidget(
                      avatarUrl: current.avatarUrl,
                      name: current.fullname,
                      username: current.username,
                      id: current.id,
                      bio: current.bio,
                      isFollowing: current.isFollowing,
                    );
                  },
                  // ),
                ),
      // else if (snapshot.hasError) {
      //   return const Center(child: Text('Error fetching data'));
      // }
    );
  }
}
