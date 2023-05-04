import 'package:flutter/services.dart';

class MinutesOrSecondsInputFormatter extends TextInputFormatter {
  MinutesOrSecondsInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;
    final int? val = int.tryParse(newText);
    if (val != null && (val < 0 || val > 59)) {
      newText = oldValue.text;
      newSelection = oldValue.selection;
    }
    return TextEditingValue(
      text: newText,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
