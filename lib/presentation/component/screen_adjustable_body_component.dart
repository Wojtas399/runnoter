import 'package:flutter/material.dart';

import '../config/ui_sizes.dart';

class ScreenAdjustableBody extends StatelessWidget {
  final Widget child;

  const ScreenAdjustableBody({
    super.key,
    required this.child,
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
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              padding: const EdgeInsets.all(24),
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
