import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zola/screens/search/components/list_search_user.dart';
import 'package:zola/screens/search/components/search_contact.dart';
import 'components/search_keyword.dart';
import 'package:zola/services/search_history.dart' as search_history;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchTextController = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {context.pop()}),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
			autofocus: true,
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            onSubmitted: (value) async {
              context.push('/search-result?search=$value');
              await search_history.createSearchTextHistory(value);
            },
            controller: searchTextController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: 'Tìm kiếm',
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
        centerTitle: true,
      ),
      body: searchTextController.text.isNotEmpty &&
              searchTextController.text != ""
          ? ListSearchUser(
              searchText: searchText,
            )
          : Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 20.0),
                  child: Text(
                    'Gần đây',
                    style: GoogleFonts.notoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: HexColor("#4f4f4f"),
                    ),
                  ),
                ),
                const SizedBox(height: 125, child: SearchContact()),
                const Divider(),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Từ khóa đã tìm kiếm",
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: HexColor("#4f4f4f"),
                    ),
                  ),
                ),
                const Expanded(
                  child: SearchKeyword(),
                )
              ],
            ),
    );
  }
}
