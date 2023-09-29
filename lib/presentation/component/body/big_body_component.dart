import 'package:flutter/material.dart';

class BigBody extends StatelessWidget {
  final Widget child;

  const BigBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: child,
      ),
    );
  }
}
