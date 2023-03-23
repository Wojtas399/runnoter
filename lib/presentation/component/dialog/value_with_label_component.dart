import 'package:flutter/material.dart';

class ValueWithLabelComponent extends StatelessWidget {
  final String label;
  final String value;
  final IconData? iconData;
  final VoidCallback? onPressed;

  const ValueWithLabelComponent({
    super.key,
    required this.label,
    required this.value,
    this.iconData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(iconData),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
