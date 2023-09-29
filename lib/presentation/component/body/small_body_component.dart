import 'package:flutter/material.dart';

class SmallBody extends StatelessWidget {
  final Widget child;
  final double minHeight;

  const SmallBody({super.key, required this.child, this.minHeight = 0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500, minHeight: minHeight),
        child: child,
      ),
    );
  }
}
