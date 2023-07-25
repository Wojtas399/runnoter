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
      newSelection = newSelection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      );
    } else if (newText == '.') {
      newText = '0.';
      newSelection = newSelection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      );
    }
    newText = _removeUnwantedCharacters(newText);
    return TextEditingValue(
      text: newText,
      selection: newSelection,
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
