import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleUserItem extends StatelessWidget {
  String avatarUrl;
  String name;
  String username;

  SimpleUserItem(
      {super.key,
      required this.avatarUrl,
      required this.name,
      required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      child: GestureDetector(
		onTap: () => context.push('/user_detail/$username'),
		child: SizedBox(
		  // width: 150,
		  child: Column(
			children: [
			  CircleAvatar(
				radius: 30,
				backgroundImage: NetworkImage(
				  avatarUrl,
				),
			  ),
			  const SizedBox(height: 8.0),
			  Text(
				name,
				style: GoogleFonts.notoSans(
					fontSize: 15.0, fontWeight: FontWeight.normal),
			  ),
			  Text(
				'@$username',
				style: GoogleFonts.notoSans(color: Colors.grey, fontSize: 12),
			  ),
			],
		  ),
		),
	  ),
    );
  }
}
