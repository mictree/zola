import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';

class TopSearchBar extends StatefulWidget {
  const TopSearchBar({super.key});
  @override
  State<TopSearchBar> createState() => _TopSearchBarState();
}

class _TopSearchBarState extends State<TopSearchBar> {
  @override
  Widget build(BuildContext context) {
    return const Row(children: [ Text("hello"), Icon(Iconsax.search_favorite)],);
  }
}
