import 'package:flutter/material.dart';

class StatusItem extends StatelessWidget {
  final String imgUrl;

  const StatusItem({Key? key, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60.0,
        width: 60.0,
        margin: const EdgeInsets.only(right: 32),
        decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent, width: 2),
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(imgUrl))));
  }
}
