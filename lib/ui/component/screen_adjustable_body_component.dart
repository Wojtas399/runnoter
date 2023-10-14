import 'package:flutter/material.dart';

class ScreenAdjustableBody extends StatelessWidget {
  final Widget child;
  final double maxContentWidth;

  const ScreenAdjustableBody({
    super.key,
    required this.child,
    required this.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              padding: const EdgeInsets.all(24),
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
