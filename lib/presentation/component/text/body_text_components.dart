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

class BodyMedium extends StatelessWidget {
  final String data;
  final Color? color;
  final FontWeight? fontWeight;

  const BodyMedium(
    this.data, {
    super.key,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
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
