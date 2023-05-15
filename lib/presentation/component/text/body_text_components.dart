import 'package:flutter/material.dart';

class BodyLarge extends StatelessWidget {
  final String data;

  const BodyLarge(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
