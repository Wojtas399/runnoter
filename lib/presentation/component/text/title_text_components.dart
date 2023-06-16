import 'package:flutter/material.dart';

class TitleLarge extends StatelessWidget {
  final String data;

  const TitleLarge(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class TitleMedium extends StatelessWidget {
  final String data;

  const TitleMedium(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleMedium,
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
