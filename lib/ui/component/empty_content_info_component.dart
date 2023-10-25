import 'package:flutter/material.dart';

import 'gap/gap_components.dart';
import 'text/body_text_components.dart';
import 'text/title_text_components.dart';

class EmptyContentInfo extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;

  const EmptyContentInfo({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).colorScheme.outline;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 48, color: color),
          if (title != null) ...[
            const Gap16(),
            TitleLarge(title!, color: color, textAlign: TextAlign.center),
          ],
          if (subtitle != null) ...[
            const Gap8(),
            BodyLarge(subtitle!, color: color, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}
