import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  const ImageSlider({Key? key, required this.imageUrls}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            context.push('/image-view?initialIndex=$_currentImageIndex',
                extra: widget.imageUrls);
          },
          child: SizedBox(
            height: 300,
            child: Stack(
              children: [
                CarouselSlider(
                  items: widget.imageUrls.map((url) {
                    return ClipRRect(
					  borderRadius: BorderRadius.circular(10),
					  child: CachedNetworkImage(
						imageUrl: url,
						fit: BoxFit.cover,
						progressIndicatorBuilder:
							(context, url, downloadProgress) => Center(
						  child: CircularProgressIndicator(
							  value: downloadProgress.progress),
						),
						errorWidget: (context, url, error) => Icon(Icons.error),
					  ),
					);
                  }).toList(),
                  options: CarouselOptions(
                    height: 400,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      '${_currentImageIndex + 1}/${widget.imageUrls.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.map((url) {
            int index = widget.imageUrls.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentImageIndex == index
                    ? Colors.grey[200]
                    : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
