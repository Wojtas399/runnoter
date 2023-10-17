import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final String label;
  final bool isDisabled;
  final VoidCallback onPressed;

  const BigButton({
    super.key,
    required this.label,
    this.isDisabled = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: FilledButton(
          onPressed: isDisabled ? null : onPressed,
          child: Text(label),
        ),
      ),
    );
  }
}
