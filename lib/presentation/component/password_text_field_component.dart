import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordTextFieldComponent extends StatefulWidget {
  final String? label;
  final bool isRequired;
  final Function(String? value)? onChanged;
  final Function(PointerDownEvent event)? onTapOutside;
  final Function(String value)? onSubmitted;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;

  const PasswordTextFieldComponent({
    super.key,
    this.label,
    this.isRequired = false,
    this.onChanged,
    this.onTapOutside,
    this.onSubmitted,
    this.controller,
    this.validator,
  });

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<PasswordTextFieldComponent> {
  late bool _isVisible;

  @override
  void initState() {
    _isVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscuringCharacter: '*',
      obscureText: !_isVisible,
      decoration: InputDecoration(
        label: Text(
          widget.label ?? Str.of(context).password,
        ),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _onVisibilityIconPressed,
        ),
      ),
      onChanged: widget.onChanged,
      onTapOutside: widget.onTapOutside,
      controller: widget.controller,
      onFieldSubmitted: widget.onSubmitted,
      validator: (String? value) {
        return _validate(value, context);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  void _onVisibilityIconPressed() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  String? _validate(String? value, BuildContext context) {
    if (widget.isRequired && value == '') {
      return Str.of(context).requiredFieldMessage;
    }
    final String? Function(String? value)? customValidator = widget.validator;
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  }
}
