import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTextItem extends StatefulWidget {
  final String text;
  final double? fontSize;

  const RichTextItem({Key? key, required this.text, this.fontSize = 16})
      : super(key: key);

  @override
  _RichTextItemState createState() => _RichTextItemState();
}

class _RichTextItemState extends State<RichTextItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final maxLines = isExpanded ? null : 2;

    List<TextSpan> commentSpans = [];

    RegExp usernameRegex = RegExp(r'@(\w+)');
    RegExp hashtagRegex = RegExp(r'#(\w+)');

    List<String> words = widget.text.split(' ');

    for (String word in words) {
      if (usernameRegex.hasMatch(word)) {
        commentSpans.add(TextSpan(
          text: '$word ',
          style: TextStyle(
            fontSize: widget.fontSize,
            color: Colors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Handle username click
              print('click username');
            },
        ));
      } else if (hashtagRegex.hasMatch(word)) {
        commentSpans.add(TextSpan(
          text: '$word ',
          style: TextStyle(
            fontSize: widget.fontSize,
            color: Colors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Handle hashtag click
              print('click hashtag');
            },
        ));
      } else {
        commentSpans.add(TextSpan(
          text: '$word ',
          style: TextStyle(fontSize: widget.fontSize, color: Colors.black),
        ));
      }
    }

    final textWidget = RichText(
      text: TextSpan(children: commentSpans),
      maxLines: maxLines,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        textWidget,
        if (!isExpanded && widget.text.length > 100)
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = true;
              });
            },
            child: const Text(
              'Xem thêm',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
