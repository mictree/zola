import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class HashtagWidget extends StatelessWidget {
  final String name;
  final int count;

  const HashtagWidget({super.key, required this.name, required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
		onTap: () => GoRouter.of(context).push('/search-result?search=${name.substring(1)}'),
	  child: Container(
		decoration: BoxDecoration(
		  borderRadius: BorderRadius.circular(15.0),
		  color: Colors.white,
		  boxShadow: [
			BoxShadow(
			  color: Colors.grey.withOpacity(0.5),
			  spreadRadius: 2,
			  blurRadius: 5,
			  offset: const Offset(0, 3),
			),
		  ],
		),
		child: Padding(
		  padding: const EdgeInsets.all(10.0),
		  child: Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
			  Text(
				name,
				style: const TextStyle(
				  fontSize: 18.0,
				  fontWeight: FontWeight.bold,
				  color: Colors.blue,
				),
			  ),
			  const SizedBox(height: 5.0),
			  Text(
				'$count bài viết',
				style: const TextStyle(
				  fontSize: 16.0,
				  color: Colors.grey,
				),
			  ),
			],
		  ),
		),
	  ),
	);
  }
}

class RoundedCorner extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    final radius = 15.0;

    final path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
      ..lineTo(size.width, size.height - radius)
      ..arcToPoint(Offset(size.width - radius, size.height),
          radius: Radius.circular(radius))
      ..lineTo(radius, size.height)
      ..arcToPoint(Offset(0, size.height - radius),
          radius: Radius.circular(radius))
      ..lineTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
