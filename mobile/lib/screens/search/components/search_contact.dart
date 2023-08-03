import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zola/models/search_user_model.dart';
import 'package:zola/widgets/simple_user_item.dart';
import 'package:zola/services/search_history.dart' as search_history;

class SearchContact extends StatefulWidget {
  const SearchContact({super.key});

  @override
  State<SearchContact> createState() => _SearchContactState();
}

class _SearchContactState extends State<SearchContact> {
  List<SearchUserModel> searchUserHistory = [];

  @override
  void initState() {
    // TODO: implement initState
    search_history.getSearchUserHistory().then((value) {
      setState(() {
        searchUserHistory = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
	  itemCount: searchUserHistory.length,
      itemBuilder: (BuildContext context, int index) {
        return SimpleUserItem(
			key: Key(Uuid().v4()),
          avatarUrl: searchUserHistory[index].avatarUrl,
          name: searchUserHistory[index].fullname,
          username: searchUserHistory[index].username,
        );
      },
    );
  }
}
