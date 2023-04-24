import 'package:flutter/material.dart';

class ScrollableContent extends StatelessWidget {
  final Widget child;

  const ScrollableContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: constraints.copyWith(
              minHeight: constraints.maxHeight,
              maxHeight: double.infinity,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
