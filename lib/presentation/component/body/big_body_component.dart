import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../config/body_sizes.dart';

class BigBody extends StatelessWidget {
  final Widget child;

  const BigBody({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: GetIt.I.get<BodySizes>().bigBodyWidth,
        ),
        child: child,
      ),
    );
  }
}
