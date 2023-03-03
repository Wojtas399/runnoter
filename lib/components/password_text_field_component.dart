import 'package:flutter/material.dart';

class PasswordTextFieldComponent extends StatefulWidget {
  const PasswordTextFieldComponent({
    super.key,
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
        label: const Text('Hasło'),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _onVisibilityIconPressed,
        ),
      ),
    );
  }

  void _onVisibilityIconPressed() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
}
