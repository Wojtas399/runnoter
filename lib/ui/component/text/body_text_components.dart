import 'package:flutter/material.dart';

class BodyLarge extends StatelessWidget {
  final String data;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  const BodyLarge(
    this.data, {
    super.key,
    this.fontWeight,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: fontWeight,
            color: color,
          ),
      textAlign: textAlign,
    );
  }
}

class BodyMedium extends StatelessWidget {
  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const BodyMedium(
    this.data, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
    );
  }
}

class BodySmall extends StatelessWidget {
  final String data;
  final Color? color;

  const BodySmall(
    this.data, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
    );
  }
}
