import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const BigButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label.toUpperCase(),
        ),
      ),
    );
  }
}
