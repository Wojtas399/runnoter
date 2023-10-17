import 'package:flutter/material.dart';

class HeadlineMedium extends StatelessWidget {
  final String data;
  final FontWeight? fontWeight;

  const HeadlineMedium(
    this.data, {
    super.key,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: fontWeight,
          ),
    );
  }
}
