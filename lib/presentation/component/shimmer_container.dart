import 'package:flutter/material.dart';

class ShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxConstraints? constraints;

  const ShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
