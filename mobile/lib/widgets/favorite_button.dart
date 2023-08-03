import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FavoriteButton extends StatefulWidget {
  bool isFavorite = false;
  String id = '';
  Function onLike;

  FavoriteButton(
      {Key? key,
      this.isFavorite = false,
      required this.id,
      required this.onLike})
      : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(begin: 24.0, end: 32.0).animate(_controller);
    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.redAccent,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onLike();
        setState(() {
          _isFavorite = !_isFavorite;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: _isFavorite
            ? const Icon(
                Iconsax.heart5,
                key: ValueKey('favorite'),
                color: Colors.red,
                // size: 100,
              )
            : const Icon(
                Iconsax.heart,
                key: ValueKey('favorite_border'),
                color: Colors.grey,
                // size: 100,
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
