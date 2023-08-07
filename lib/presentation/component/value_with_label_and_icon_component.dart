import 'package:flutter/material.dart';

import 'gap/gap_horizontal_components.dart';

class ValueWithLabelAndIcon extends StatelessWidget {
  final String value;
  final String? label;
  final IconData? iconData;
  final VoidCallback? onPressed;
  final Color? color;

  const ValueWithLabelAndIcon({
    super.key,
    required this.value,
    this.label,
    this.iconData,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: label != null ? 8 : 20,
          ),
          child: Row(
            children: [
              if (iconData != null)
                Icon(
                  iconData,
                  color: color ?? theme.colorScheme.onSurfaceVariant,
                ),
              if (iconData != null) const GapHorizontal16(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (label != null)
                    Text(
                      label!,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: color ?? theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  if (label != null) const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(color: color),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
