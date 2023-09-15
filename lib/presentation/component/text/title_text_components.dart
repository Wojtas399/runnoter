import 'package:flutter/material.dart';

class TitleLarge extends StatelessWidget {
  final String data;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const TitleLarge(
    this.data, {
    super.key,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: fontWeight,
            color: color,
          ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

class TitleMedium extends StatelessWidget {
  final String data;
  final Color? color;

  const TitleMedium(this.data, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
    );
  }
}

class TitleSmall extends StatelessWidget {
  final String data;
  final Color? color;

  const TitleSmall(this.data, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color),
    );
  }
}
