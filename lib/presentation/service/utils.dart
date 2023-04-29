import 'package:flutter/material.dart';

void unfocusInputs() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String twoDigits(int number) {
  return number.toString().padLeft(2, '0');
}

bool areListsEqual(List list1, List list2) {
  if (list1.length != list2.length) {
    return false;
  }
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }
  return true;
}
