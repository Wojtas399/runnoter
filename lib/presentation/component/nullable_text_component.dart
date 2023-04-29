import 'package:flutter/material.dart';

class NullableText extends StatelessWidget {
  final String? text;

  const NullableText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text ?? '--');
  }
}
