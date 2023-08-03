import 'package:flutter/material.dart';
import 'package:zola/widgets/video_player_detail.dart';

class VideoViewScreen extends StatefulWidget {
  final String url;

  const VideoViewScreen({required this.url});

  @override
  _VideoViewScreenState createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Video Player'),
        ),
        body: VideoPlayerDetail(
          videoUrl: widget.url,
          isShowController: true,
          playFromUrl: true,
          isAutoPlay: true,
        ));
  }
}
