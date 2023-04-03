import 'package:flutter/material.dart';

class SlideToTopAnim extends SlideTransition {
  final Animation<double> animation;

  SlideToTopAnim({
    super.key,
    required this.animation,
    required super.child,
  }) : super(
          position: Tween(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutQuart,
            ),
          ),
        );
}
