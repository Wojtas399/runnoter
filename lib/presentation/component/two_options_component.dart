import 'package:flutter/material.dart';

import 'text/label_text_components.dart';

class OptionParams<T> {
  final String label;
  final T value;

  const OptionParams({required this.label, required this.value});
}

class TwoOptions<T> extends StatelessWidget {
  final String? label;
  final T selectedValue;
  final OptionParams<T> option1;
  final OptionParams<T> option2;
  final void Function(T value) onChanged;

  const TwoOptions({
    super.key,
    this.label,
    required this.selectedValue,
    required this.option1,
    required this.option2,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          LabelLarge(label!),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: Text(option1.label),
                leading: Radio<T>(
                  value: option1.value,
                  groupValue: selectedValue,
                  onChanged: _onChanged,
                ),
                onTap: () => onChanged(option1.value),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: Text(option2.label),
                leading: Radio<T>(
                  value: option2.value,
                  groupValue: selectedValue,
                  onChanged: _onChanged,
                ),
                onTap: () => onChanged(option2.value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onChanged(T? value) {
    if (value != null) onChanged(value);
  }
}
