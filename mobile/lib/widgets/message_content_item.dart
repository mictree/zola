import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zola/widgets/simple_video_player.dart';
import 'package:zola/widgets/video_player_detail.dart';

class MessageContentItem extends StatelessWidget {
  String type;
  String content;
  bool isSending;
  bool isFromFile;
  MessageContentItem(
      {required this.type,
      required this.content,
      this.isSending = false,
      this.isFromFile = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (type == "image") {
      return GestureDetector(
        onTap: () =>
            context.push('/image-view?initialIndex=0', extra: [content]),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: isFromFile
                ? Image.file(
                    File(content),
                    fit: BoxFit.fitWidth,
                    width: 200,
                  )
                : CachedNetworkImage(
                    imageUrl: content,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
          ),
        ),
      );
    }
    if (type == "video") {
      return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 350),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SimpleVideoPlayer(
              videoUrl: content,
              isFromFile: isFromFile,
            ),
          ));
    }
    if (type == "file") {
      return Row(
        children: [
          const Icon(Icons.insert_drive_file),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Download.cpp",
            style: GoogleFonts.notoSans(fontSize: 15),
          ),
        ],
      );
    }

    if (type == "audio") {
      return const Placeholder();
    }
    return Text(
      content,
      style: GoogleFonts.notoSans(fontSize: 16),
    );
  }
}
