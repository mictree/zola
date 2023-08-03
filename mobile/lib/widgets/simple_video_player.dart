import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isFromFile;
  const SimpleVideoPlayer(
      {Key? key, required this.videoUrl, this.isFromFile = false})
      : super(key: key);

  @override
  _SimpleVideoPlayerState createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  late VideoPlayerController _videoController;
  bool _isMuted = false;
  bool _isPlaying = true;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isError = false;

  @override
  void initState() {
    super.initState();

    if (widget.isFromFile) {
      _videoController = VideoPlayerController.file(File(widget.videoUrl));
    } else {
      _videoController = VideoPlayerController.network(widget.videoUrl);
    }
    _videoController.setLooping(true);

    _videoController.addListener(() {
      if (!_videoController.value.isPlaying &&
          _videoController.value.position == _videoController.value.duration) {
        _videoController.seekTo(Duration.zero);
      }
    });

    _initializeVideoPlayerFuture = _videoController.initialize();

    _videoController.addListener(() {
      if (_videoController.value.hasError) {
        print(_videoController.value.errorDescription);
        setState(() {
          _isError = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoController.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 0) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return VisibilityDetector(
              key: Key(widget.videoUrl),
              onVisibilityChanged: _onVisibilityChanged,
              child: GestureDetector(
                onTap: () =>
                    context.push('/video-view', extra: widget.videoUrl),
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // check if video url is not broken
                      _videoController.value.isInitialized && !_isError
                          ? AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            )
                          : Container(),

                      _isError
                          ? Container(
                              height: 250,
                              width: double.infinity,
                              // add decoration to make it look like a placeholder
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Icon(Icons.error),
                              ),
                            )
                          : Container(),

                      _isError
                          ? Container()
                          : Positioned(
                              right: 5,
                              bottom: 5,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(_isMuted
                                        ? Icons.volume_off
                                        : Icons.volume_up),
                                    onPressed: _toggleMute,
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    icon: Icon(_isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow),
                                    onPressed: () {
                                      setState(() {
                                        if (_videoController.value.isPlaying) {
                                          _videoController.pause();
                                          _isPlaying = false;
                                        } else {
                                          _videoController.play();
                                          _isPlaying = true;
                                        }
                                      });
                                    },
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
