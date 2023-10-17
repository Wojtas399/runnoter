import 'package:flutter/material.dart';

enum AnimatedRefreshIndicatorPosition { top, bottom }

class AnimatedRefreshIndicator extends StatefulWidget {
  final bool isLoading;
  final AnimatedRefreshIndicatorPosition position;

  const AnimatedRefreshIndicator({
    super.key,
    required this.isLoading,
    this.position = AnimatedRefreshIndicatorPosition.top,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AnimatedRefreshIndicator> {
  double yPosition = -50;

  @override
  void didUpdateWidget(covariant AnimatedRefreshIndicator oldWidget) {
    setState(() {
      yPosition = widget.isLoading ? 25 : -50;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: widget.position == AnimatedRefreshIndicatorPosition.top
          ? yPosition
          : null,
      left: 0,
      right: 0,
      bottom: widget.position == AnimatedRefreshIndicatorPosition.bottom
          ? yPosition
          : null,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 40,
              height: 40,
              child: const CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
        ],
      ),
    );
  }
}
