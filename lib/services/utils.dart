import 'package:flutter/material.dart';

void unfocusInputs() {
  FocusManager.instance.primaryFocus?.unfocus();
}
