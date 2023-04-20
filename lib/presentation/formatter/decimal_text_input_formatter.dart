import 'dart:math' as math;

import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({
    required this.decimalRange,
  }) : assert(decimalRange > 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;
    if (newText.contains('.') && _doesValHaveTooMuchDecimals(newText)) {
      newText = _removeSpecialCharacters(oldValue.text);
      newSelection = oldValue.selection;
    } else if (newText == '.') {
      newText = '0.';
      newSelection = newSelection.copyWith(
        baseOffset: math.min(newText.length, newText.length + 1),
        extentOffset: math.min(newText.length, newText.length + 1),
      );
    }
    return TextEditingValue(
      text: newText,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }

  String _removeSpecialCharacters(String value) => value.replaceAll(
        RegExp('[^0-9.]'),
        '',
      );

  bool _doesValHaveTooMuchDecimals(String val) =>
      val.substring(val.indexOf('.') + 1).length > decimalRange;
}
