import 'package:flutter/material.dart';

void unfocusInputs() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String twoDigits(int number) {
  return number.toString().padLeft(2, '0');
}
