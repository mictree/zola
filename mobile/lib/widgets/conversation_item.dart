import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/widgets/group_avatar.dart';
import 'package:zola/utils/datetime_formater.dart';

class ConversationItem extends StatefulWidget {
  String id;
  String name;
  String messageText;
  String sender;
  String imageUrl;
  String time;
  bool isMessageRead;
  bool isGroup;
  ConversationItem(
      {super.key,
      required this.id,
      required this.name,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      required this.sender,
      this.isGroup = false});
  @override
  _ConversationItemState createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        context.push(RouteConst.message.replaceAll(':id', widget.id)),
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  widget.isGroup
                      ? GroupAvatar(
                          name: widget.name,
                          imageUrl: widget.imageUrl,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                  //   CircleAvatar(
                  //       backgroundImage: NetworkImage(widget.imageUrl),
                  //       maxRadius: 24,
                  //     ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.name,
                                style: GoogleFonts.notoSans(fontSize: 16),
                              ),
                              Text(
                                DateTimeFormatterHelper.timeDifference(
                                    widget.time),
                                style: GoogleFonts.notoSans(
                                    fontSize: 12,
                                    fontWeight: widget.isMessageRead
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 243, 243, 243),
                                width: 1.0,
                              ),
                            )),
                            child: // if message text is null, show nothing
                                widget.messageText == ''
                                    ? Text(
                                        'Chưa có tin nhắn nào',
                                        style: GoogleFonts.notoSans(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                            fontWeight: widget.isMessageRead
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      )
                                    : Row(
                                        children: [
											widget.sender != "" ?
                                          Text(
                                            '${widget.sender}: ',
                                            style: GoogleFonts.notoSans(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: widget.isMessageRead
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                          )
										  : Container(),
                                          Text(
                                            widget.messageText.length > 20
                                                ? '${widget.messageText.substring(0, 20)}...'
                                                : widget.messageText,
                                            style: GoogleFonts.notoSans(
                                                fontSize: 13,
                                                color: Colors.grey.shade600,
                                                fontWeight: widget.isMessageRead
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                          ),
                                        ],
                                      ),
                          )
                        ],
                      ),
                    ),
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
