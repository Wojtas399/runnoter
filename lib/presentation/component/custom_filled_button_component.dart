import 'package:flutter/material.dart';

enum ButtonSize {
  medium(150, 52),
  big(300, 52);

  final double width;
  final double height;

  const ButtonSize(this.width, this.height);
}

class CustomFilledButton extends StatelessWidget {
  final ButtonSize size;
  final String label;
  final bool isDisabled;
  final Color? color;
  final VoidCallback onPressed;

  const CustomFilledButton({
    super.key,
    this.size = ButtonSize.big,
    required this.label,
    this.isDisabled = false,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width,
          height: size.height,
          child: FilledButton(
            onPressed: isDisabled ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: color,
            ),
            child: Text(label),
          ),
        ),
      ],
    );
  }
}
