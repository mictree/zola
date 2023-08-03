import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePic extends StatelessWidget {
  final String avatar;

  const ProfilePic({
    Key? key,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: DecorationImage(
                image: NetworkImage(avatar ??
                    "https://png.pngtree.com/png-vector/20210604/ourmid/pngtree-gray-avatar-placeholder-png-image_3416697.jpg"),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(100.0)),
              border: Border.all(
                color: Colors.white,
                width: 4.0,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              height: 32,
              width: 32,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: const FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                    Iconsax.camera5,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
