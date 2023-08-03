import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:zola/screens/profile/components/profile_pic.dart';
import 'package:zola/models/user_info_model.dart';
import 'package:zola/services/users.dart' as user_service;
import 'package:zola/utils/datetime_formater.dart';

class UserInfoOverview extends StatefulWidget {
  final UserProfileInfoModel userInfoModel;

  const UserInfoOverview({
    Key? key,
    required this.userInfoModel,
  }) : super(key: key);

  @override
  State<UserInfoOverview> createState() => _UserInfoOverviewState();
}

class _UserInfoOverviewState extends State<UserInfoOverview> {
  bool _isFollowing = false;

  void _toggleFollow() {
    try {
      if (_isFollowing) {
        user_service.unFollowUser(widget.userInfoModel.username);
        setState(() {
          widget.userInfoModel.follower--;
        });
      } else {
        user_service.followUser(widget.userInfoModel.username);
        setState(() {
          widget.userInfoModel.follower++;
        });
      }
      setState(() {
        _isFollowing = !_isFollowing;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isFollowing = widget.userInfoModel.isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: double.maxFinite,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.userInfoModel.coverUrl == ""
                        ? "https://i0.wp.com/corvallisddc.org/wp-content/uploads/2021/10/placeholder-664.png?fit=1200%2C800&ssl=1"
                        : widget.userInfoModel.coverUrl),
                  ),
                ),
              ),
              Positioned(
                bottom: -84,
                left: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfilePic(avatar: widget.userInfoModel.avatarUrl),
                    Text(
                      widget.userInfoModel.fullname.length > 15
						  ? "${widget.userInfoModel.fullname.substring(0, 15)}..."
						  : widget.userInfoModel.fullname,
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text("@${widget.userInfoModel.username}",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ],
          ),
        ),
        widget.userInfoModel.isMe
            ? Container()
            : Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: _toggleFollow,
                  child: Container(
                    width: 128,
                    decoration: BoxDecoration(
                        color: _isFollowing ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        _isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                        style: _isFollowing
                            ? GoogleFonts.notoSans(color: Colors.black)
                            : GoogleFonts.notoSans(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 100),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ReadMoreText(
            widget.userInfoModel.bio,
            trimLines: 4,
            colorClickableText: Colors.pink,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Đọc thêm',
            trimExpandedText: 'Ẩn nội dung',
            style: GoogleFonts.poppins(fontSize: 18),
            moreStyle: GoogleFonts.poppins(fontSize: 18),
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Row(children: [
                Text(
                  "${widget.userInfoModel.following}",
                  style: GoogleFonts.poppins(
                      fontSize: 16, decorationThickness: 10),
                ),
                Text(" Đang theo dõi",
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
              ]),
              const SizedBox(width: 16),
              Row(
                children: [
                  Text(
                    "${widget.userInfoModel.follower}",
                    style: GoogleFonts.poppins(
                        fontSize: 16, decorationThickness: 10),
                  ),
                  Text(" Người theo dõi",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Icon(Iconsax.calendar_2),
            Text(
              "Tham gia vào: ${DateTimeFormatterHelper.formatToDDMMYYYY(widget.userInfoModel.createdAt)}",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ]),
        ),
      ],
    );
  }
}
