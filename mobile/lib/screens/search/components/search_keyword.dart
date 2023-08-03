import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zola/models/search_text_model.dart';
import 'package:zola/services/search_history.dart' as search_history;

class SearchKeyword extends StatefulWidget {
  const SearchKeyword({super.key});

  @override
  State<SearchKeyword> createState() => _SearchKeywordState();
}

class _SearchKeywordState extends State<SearchKeyword> {
  List<SearchTextModel> searchTextHistory = [];

  @override
  void initState() {
    // TODO: implement initState
    search_history.getSearchTextHistory().then((value) {
      setState(() {
        searchTextHistory = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: searchTextHistory.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => context
              .push('/search-result?search=${searchTextHistory[index].text}'),
          child: ListTile(
            title: Text(searchTextHistory[index].text),
            leading: const Icon(Icons.search),
            // delete trailing
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await search_history
                    .deleteSearchHistory(searchTextHistory[index].id);
                setState(() {
                  searchTextHistory.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }
}
