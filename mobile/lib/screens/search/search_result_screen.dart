import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'components/list_search_user.dart';
import 'components/search_post.dart';

class SearchResultScreen extends StatefulWidget {
  String searchText = "";
  SearchResultScreen({required this.searchText, super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen>
    with AutomaticKeepAliveClientMixin<SearchResultScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.text = widget.searchText;
    searchText = widget.searchText;
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              // Perform search functionality here
            },
            onSubmitted: (value) {
              print(value);
              setState(() {
                searchText = value;
              });
            },
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text: 'Mới nhất'),
              Tab(text: 'Nổi bật'),
              Tab(text: 'Người dùng'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Nội dung cho tab "Mới nhất"
            SearchPost(
              searchText: searchText,
              filter: 'new',
            ),
            // Nội dung cho tab "Nổi bật"
            SearchPost(
              searchText: searchText,
              filter: 'hot',
            ),
            // Nội dung cho tab "Người dùng"
            ListSearchUser(
              searchText: searchText,
            )
          ],
        ),
      ),
    );
  }
}
