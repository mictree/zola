import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zola/services/users.dart' as user_service;
import 'package:zola/services/search_history.dart' as search_history_service;

class UserFollowingWidget extends StatefulWidget {
  final String id;
  final String username;
  final String name;
  final String avatarUrl;
  final String bio;
  bool isFollowing;

  UserFollowingWidget(
      {super.key,
      required this.id,
      required this.username,
      required this.name,
      required this.avatarUrl,
      required this.bio,
      this.isFollowing = false});

  @override
  _UserFollowingWidgetState createState() => _UserFollowingWidgetState();
}

class _UserFollowingWidgetState extends State<UserFollowingWidget> {
  bool _isFollowing = false;

  void _toggleFollow() {
    try {
      if (_isFollowing) {
        user_service.unFollowUser(widget.username);
      } else {
        user_service.followUser(widget.username);
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
    setState(() {
      _isFollowing = widget.isFollowing;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        await search_history_service.createSearchUserHistory(widget.id);
        // ignore: use_build_context_synchronously
        context.push('/user_detail/${widget.username}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.avatarUrl),
              radius: 25,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('@${widget.username}',
                      style: GoogleFonts.notoSans(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(
                    widget.bio,
                    style: GoogleFonts.notoSans(fontSize: 16),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: _toggleFollow,
              child: Container(
                width: 128,
                decoration: BoxDecoration(
                    color: _isFollowing ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          ],
        ),
      ),
    );
  }
}
