import 'package:flutter/material.dart';

class LabelLarge extends StatelessWidget {
  final String data;

  const LabelLarge(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}

class LabelMedium extends StatelessWidget {
  final String data;

  const LabelMedium(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}
