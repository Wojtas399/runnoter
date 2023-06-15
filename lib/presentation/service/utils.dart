import 'package:flutter/material.dart';

void unfocusInputs() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String twoDigits(int number) {
  return number.toString().padLeft(2, '0');
}

String doubleDecimal(double number) => number.toStringAsFixed(2);

String withoutUnusedZeros(double number) {
  RegExp regex = RegExp(r'([.]*0+)(?!.*\d)');

  return number.toString().replaceAll(regex, '');
}
