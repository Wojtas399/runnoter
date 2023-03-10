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
    return SizedBox(
      width: 300,
      height: 52,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        child: Text(
          label.toUpperCase(),
        ),
      ),
    );
  }
}
