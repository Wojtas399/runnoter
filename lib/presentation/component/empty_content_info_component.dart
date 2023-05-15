import 'package:flutter/material.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Icon(icon, size: 48, color: color),
            ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: color,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                  ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
