import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zola/theme.dart';
import 'package:zola/widgets/status_item.dart';

class NewFeed extends StatelessWidget {
  const NewFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Bảng tin?",
                    style: GoogleFonts.getFont(primaryFont, fontSize: 24, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      SizedBox(width: 8),
                      StatusItem(
                          imgUrl: 'https://picsum.photos/200/300?random=1'),
                      StatusItem(
                          imgUrl: 'https://picsum.photos/200/300?random=2'),
                      StatusItem(
                          imgUrl: 'https://picsum.photos/200/300?random=3'),
                      StatusItem(
                          imgUrl: 'https://picsum.photos/200/300?random=4'),
                      StatusItem(
                          imgUrl: 'https://picsum.photos/200/300?random=5'),
                    ],
                  ),
                )
              ],
            )));
  }
}
