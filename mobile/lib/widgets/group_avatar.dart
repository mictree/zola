import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zola/utils/color_genarate.dart';

class GroupAvatar extends StatelessWidget {
  String name;
  String imageUrl;
  double radius;

  GroupAvatar(
      {this.radius = 30,
      required this.name,
      required this.imageUrl,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: CircleAvatar(
            maxRadius: radius,
            backgroundColor: generateColorFromString(name),
            child: Text(
              name.split(" ").take(2).map((e) => e[0]).join("").toUpperCase(),
              style: GoogleFonts.notoSans(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => const SizedBox(
                height: 20.0,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                )),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ],
    );
  }
}
