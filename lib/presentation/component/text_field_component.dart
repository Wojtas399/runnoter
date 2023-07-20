import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFieldComponent extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isLabelCentered;
  final bool isRequired;
  final bool requireHigherThan0;
  final int? maxLength;
  final bool displayCounterText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final EdgeInsets? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final Function(String? value)? onChanged;
  final String? Function(String? value)? validator;

  const TextFieldComponent({
    super.key,
    this.label,
    this.icon,
    this.isLabelCentered = false,
    this.isRequired = false,
    this.requireHigherThan0 = false,
    this.maxLength,
    this.displayCounterText = false,
    this.maxLines,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.inputFormatters,
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: label != null
            ? isLabelCentered
                ? Center(
                    child: Text(label!),
                  )
                : Text(label!)
            : null,
        prefixIcon: icon != null ? Icon(icon) : null,
        counterText: displayCounterText ? null : '',
        contentPadding: contentPadding,
      ),
      maxLength: maxLength,
      maxLines: maxLines,
      textAlign: textAlign,
      controller: controller,
      onChanged: onChanged,
      validator: (String? value) {
        return _validate(value, context);
      },
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  String? _validate(String? value, BuildContext context) {
    if (isRequired && value == '') {
      return Str.of(context).requiredFieldMessage;
    }
    if (requireHigherThan0) {
      final double? valAsNum = double.tryParse(value ?? '');
      if (valAsNum != null && valAsNum == 0) {
        return Str.of(context).requireValueHigherThan0Message;
      }
    }
    final String? Function(String? value)? customValidator = validator;
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  }
}
