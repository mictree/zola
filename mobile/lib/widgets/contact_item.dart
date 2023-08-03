import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ContactItem extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final username;

  const ContactItem(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.id,
	  required this.username});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        // context.push(RouteConst.message, extra: {'id': id})
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                    maxRadius: 24,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: GoogleFonts.notoSans(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Iconsax.call),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Iconsax.video),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
