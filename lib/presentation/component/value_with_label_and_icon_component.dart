import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
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
                color: color,
              ),
            if (iconData != null) const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: color,
                        ),
                  ),
                if (label != null) const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: color,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
