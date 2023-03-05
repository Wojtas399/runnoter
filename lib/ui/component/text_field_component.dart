import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Function(String? value)? onChanged;

  const TextFieldComponent({
    super.key,
    required this.label,
    this.icon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
      onChanged: onChanged,
    );
  }
}
