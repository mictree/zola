import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zola/models/message_model.dart';
import 'package:zola/utils/datetime_formater.dart';
import 'package:zola/widgets/message_content_item.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  const MessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Align(
        alignment: (message.messageType == "receiver"
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            message.messageType == "receiver"
                ? CachedNetworkImage(
                    imageUrl:
                        message.senderImage ?? "https://i.pravatar.cc/300",
                    placeholder: (context, url) => const SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                    errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          size: 30,
                        ),
                    imageBuilder: (context, imageProvider) => Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ))
                : const SizedBox(),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                children: [
                  Container(
                      decoration: message.contentType == "text"
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: (message.messageType == "receiver"
                                  ? Colors.white
                                  : const Color.fromARGB(255, 193, 235, 255)),
                              border: message.messageType == "receiver"
                                  ? Border.all(color: Colors.blue)
                                  : Border.all(
                                      color: const Color.fromARGB(
                                          255, 201, 201, 201),
                                    ),
                            )
                          : null,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: MessageContentItem(
                        content: message.messageContent,
                        type: message.contentType,
                        isSending: message.state == MessageState.sending,
                        isFromFile: message.isFromFile,
                      )),
                  Text(
                    DateTimeFormatterHelper.formatToDateTime(
                        message.messageTime),
                    style:
                        GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
            ),
            message.state == MessageState.sending
                ? const SizedBox(
                    width: 8,
                    height: 8,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}


// widget that return message content based on message type
// Path: lib\widgets\message_item.dart
// Compare this snippet from lib\models\message_model.dart:
