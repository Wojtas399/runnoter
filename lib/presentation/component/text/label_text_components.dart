import 'package:flutter/material.dart';

class LabelLarge extends StatelessWidget {
  final String data;
  final TextAlign? textAlign;
  final Color? color;

  const LabelLarge(
    this.data, {
    super.key,
    this.textAlign,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
          ),
      textAlign: textAlign,
    );
  }
}

class LabelMedium extends StatelessWidget {
  final String data;
  final Color? color;

  const LabelMedium(
    this.data, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
    );
  }
}
