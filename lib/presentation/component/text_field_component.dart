import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFieldComponent extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isRequired;
  final Function(String? value)? onChanged;
  final String? Function(String? value)? validator;

  const TextFieldComponent({
    super.key,
    required this.label,
    this.icon,
    this.isRequired = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
      onChanged: onChanged,
      validator: (String? value) {
        return _validate(value, context);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  String? _validate(String? value, BuildContext context) {
    if (isRequired && value == '') {
      return AppLocalizations.of(context)!.required_field_message;
    }
    final String? Function(String? value)? customValidator = validator;
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  }
}
