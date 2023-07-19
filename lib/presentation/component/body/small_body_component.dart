import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../config/body_sizes.dart';

class SmallBody extends StatelessWidget {
  final Widget child;

  const SmallBody({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: GetIt.I.get<BodySizes>().smallBodyWidth,
        ),
        child: child,
      ),
    );
  }
}
