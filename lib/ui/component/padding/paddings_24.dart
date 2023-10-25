import 'package:flutter/material.dart';

class Paddings24 extends StatelessWidget {
  final Widget child;

  const Paddings24({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}
