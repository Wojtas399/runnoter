import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordTextFieldComponent extends StatefulWidget {
  final String? label;
  final Function(String? value)? onChanged;

  const PasswordTextFieldComponent({
    super.key,
    this.label,
    this.onChanged,
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
          widget.label ?? AppLocalizations.of(context)!.password,
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
    );
  }

  void _onVisibilityIconPressed() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
}
