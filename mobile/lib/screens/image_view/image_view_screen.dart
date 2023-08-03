import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:gallery_saver/gallery_saver.dart';

class ImageViewScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewScreen({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _saveImage(String url) async {
    try {
      // Get the directory where the image will be saved
      await [Permission.manageExternalStorage, Permission.storage].request();

      bool? isSuccess = await GallerySaver.saveImage(
          widget.imageUrls[_currentIndex],
          albumName: 'Zola media');

      // Show a snackbar to indicate that the image has been saved
      if (context.mounted && isSuccess != null && isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ảnh đã được lưu'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (context.mounted && isSuccess != null && !isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lưu ảnh thất bại'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              _saveImage(widget.imageUrls[_currentIndex]);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: PhotoView(
                  key: ValueKey<int>(_currentIndex),
                  imageProvider: NetworkImage(widget.imageUrls[_currentIndex]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2.5,
                ),
              ),
            ),
            widget.imageUrls.length > 1
                ? Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: FloatingActionButton(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          if (_currentIndex > 0) {
                            _currentIndex--;
                          } else {
                            _currentIndex = widget.imageUrls.length - 1;
                          }
                        });
                      },
                    ),
                  )
                : const SizedBox(),
            widget.imageUrls.length > 1
                ? Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          if (_currentIndex < widget.imageUrls.length - 1) {
                            _currentIndex++;
                          } else {
                            _currentIndex = 0;
                          }
                        });
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
