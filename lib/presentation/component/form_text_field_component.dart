import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormTextField extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isRequired;
  final bool requireHigherThan0;
  final int? maxLength;
  final bool displayCounterText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final Function(String? value)? onChanged;
  final Function(PointerDownEvent event)? onTapOutside;
  final Function(String value)? onSubmitted;
  final String? Function(String? value)? validator;

  const FormTextField({
    super.key,
    this.label,
    this.icon,
    this.isRequired = false,
    this.requireHigherThan0 = false,
    this.maxLength,
    this.displayCounterText = false,
    this.maxLines,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.controller,
    this.onChanged,
    this.onTapOutside,
    this.onSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: label != null ? Text(label!) : null,
        prefixIcon: icon != null ? Icon(icon) : null,
        counterText: displayCounterText ? null : '',
      ),
      maxLength: maxLength,
      maxLines: maxLines,
      controller: controller,
      onChanged: onChanged,
      validator: (String? value) => _validate(value, context),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: onTapOutside,
      onFieldSubmitted: onSubmitted,
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
