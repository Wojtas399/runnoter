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
    String newText = newValue.text.replaceAll(',', '.');
    TextSelection newSelection = newValue.selection;
    if (newText.contains('.') && _isThereTooMuchDecimalDigits(newText)) {
      newText = oldValue.text;
    } else if (newText == '.') {
      newText = '0.';
    }
    newText = _removeUnwantedCharacters(newText);
    return TextEditingValue(
      text: newText,
      selection: newSelection.copyWith(
        baseOffset: math.min(newText.length, newText.length + 1),
        extentOffset: math.min(newText.length, newText.length + 1),
      ),
      composing: TextRange.empty,
    );
  }

  String _removeUnwantedCharacters(String value) => value.replaceAll(
        RegExp('[^0-9.]'),
        '',
      );

  bool _isThereTooMuchDecimalDigits(String val) =>
      val.substring(val.indexOf('.') + 1).length > decimalRange;
}
