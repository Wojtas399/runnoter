import 'package:flutter/material.dart';

import 'text/label_text_components.dart';

class ContentWithLabel extends StatelessWidget {
  final String label;
  final Widget content;

  const ContentWithLabel({
    super.key,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelMedium(label),
        const SizedBox(height: 4),
        content,
      ],
    );
  }
}
