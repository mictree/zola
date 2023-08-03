import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedTypingIndicator extends StatefulWidget {
  const AnimatedTypingIndicator({super.key});

  @override
  _AnimatedTypingIndicatorState createState() =>
      _AnimatedTypingIndicatorState();
}

class _AnimatedTypingIndicatorState extends State<AnimatedTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dot1Animation;
  late Animation<double> _dot2Animation;
  late Animation<double> _dot3Animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _dot1Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.33, curve: Curves.easeInOut),
      ),
    );
    _dot2Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.66, curve: Curves.easeInOut),
      ),
    );
    _dot3Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 1, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      alignment: Alignment.topLeft,
      child: Container(
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _dot1Animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _dot1Animation.value,
                  child: child,
                );
              },
              child: Text('.', style: GoogleFonts.notoSans(fontSize: 32)),
            ),
            AnimatedBuilder(
              animation: _dot2Animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _dot2Animation.value,
                  child: child,
                );
              },
              child: Text('.', style: GoogleFonts.notoSans(fontSize: 32)),
            ),
            AnimatedBuilder(
              animation: _dot3Animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _dot3Animation.value,
                  child: child,
                );
              },
              child: Text('.', style: GoogleFonts.notoSans(fontSize: 32)),
            ),
          ],
        ),
      ),
    );
  }
}
