import 'package:flutter/material.dart';

class GlobalTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        inputDecorationTheme: _inputDecoration,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        inputDecorationTheme: _inputDecoration,
      );

  static const InputDecorationTheme _inputDecoration = InputDecorationTheme(
    filled: true,
  );
}
