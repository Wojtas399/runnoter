import 'package:flutter/material.dart';

class NullableText extends StatelessWidget {
  final String? text;
  final TextAlign? textAlign;
  final TextStyle? style;

  const NullableText(
    this.text, {
    super.key,
    this.textAlign,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '--',
      textAlign: textAlign,
      style: style,
    );
  }
}
