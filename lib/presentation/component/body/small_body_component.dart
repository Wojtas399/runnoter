import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../config/body_sizes.dart';

class SmallBody extends StatelessWidget {
  final Widget child;
  final double minHeight;

  const SmallBody({
    super.key,
    required this.child,
    this.minHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: GetIt.I.get<BodySizes>().smallBodyWidth,
          minHeight: minHeight,
        ),
        child: child,
      ),
    );
  }
}
