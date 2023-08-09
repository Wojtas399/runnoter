import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFieldComponent extends StatelessWidget {
  final String? label;
  final String? hintText;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool isLabelCentered;
  final bool isRequired;
  final bool requireHigherThan0;
  final int? maxLength;
  final bool displayCounterText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final EdgeInsets? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final Function(String? value)? onChanged;
  final Function(String? value)? onSubmitted;
  final Function(PointerDownEvent event)? onTapOutside;
  final String? Function(String? value)? validator;

  const TextFieldComponent({
    super.key,
    this.label,
    this.hintText,
    this.icon,
    this.suffixIcon,
    this.isLabelCentered = false,
    this.isRequired = false,
    this.requireHigherThan0 = false,
    this.maxLength,
    this.displayCounterText = false,
    this.maxLines,
    this.keyboardType,
    this.textInputAction,
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.inputFormatters,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
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
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon: suffixIcon,
        counterText: displayCounterText ? null : '',
        contentPadding: contentPadding,
      ),
      textInputAction: textInputAction,
      maxLength: maxLength,
      maxLines: maxLines,
      textAlign: textAlign,
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: (String? value) => _validate(value, context),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: onTapOutside,
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
