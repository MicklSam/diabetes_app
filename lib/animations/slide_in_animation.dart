import 'package:flutter/material.dart';

// Animation: Slide In
class SlideInAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double beginOffsetY;

  const SlideInAnimation({super.key, required this.child, this.duration = const Duration(milliseconds: 800), this.beginOffsetY = 0.3});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(0, beginOffsetY), end: Offset.zero),
      duration: duration,
      builder: (context, Offset offset, child) {
        return Transform.translate(
          offset: Offset(0, offset.dy * 100),
          child: child,
        );
      },
      child: child,
    );
  }
}
