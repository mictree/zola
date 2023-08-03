import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerDetail extends StatefulWidget {
  String videoUrl;
  bool isShowController;
  bool playFromUrl;
  bool isAutoPlay;

  VideoPlayerDetail(
      {super.key,
      required this.videoUrl,
      this.isShowController = true,
      this.playFromUrl = true,
      this.isAutoPlay = false});

  @override
  _VideoPlayerDetailState createState() => _VideoPlayerDetailState();
}

class _VideoPlayerDetailState extends State<VideoPlayerDetail> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.playFromUrl) {
      _videoController = VideoPlayerController.network(widget.videoUrl);
    } else {
      _videoController = VideoPlayerController.asset(widget.videoUrl);
    }
    _videoController.initialize().then((_) => setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            aspectRatio: _videoController.value.aspectRatio,
            showControls: widget.isShowController,
			fullScreenByDefault: true,
			autoPlay: widget.isAutoPlay,
			autoInitialize: true,
			errorBuilder: (context, errorMessage) {
			return Center(
				child: Text(
				  errorMessage,
				  style: const TextStyle(color: Colors.white),
				),
			  );
			},
          );
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: Chewie(
              controller: _chewieController,
            ),
          )
        : const SizedBox.shrink();
  }
}
