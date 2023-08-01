import 'package:flutter/material.dart';

class TitleLarge extends StatelessWidget {
  final String data;
  final FontWeight? fontWeight;

  const TitleLarge(
    this.data, {
    super.key,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: fontWeight,
          ),
    );
  }
}

class TitleMedium extends StatelessWidget {
  final String data;
  final Color? color;

  const TitleMedium(
    this.data, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
          ),
    );
  }
}

class TitleSmall extends StatelessWidget {
  final String data;

  const TitleSmall(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}
