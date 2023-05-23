import 'package:flutter/material.dart';

class LabelLarge extends StatelessWidget {
  final String data;
  final TextAlign? textAlign;

  const LabelLarge(
    this.data, {
    super.key,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.labelLarge,
      textAlign: textAlign,
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
