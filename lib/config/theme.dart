import 'package:flutter/material.dart';

class GlobalTheme {
  static const Color _primary = Color(0xFFD65A31);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light().copyWith(
          primary: _primary,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: _primary,
        ),
        scaffoldBackgroundColor: const Color(0xFF383E56),
      );
}
