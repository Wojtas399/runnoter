import 'package:flutter/material.dart';

class GlobalTheme {
  static const Color _primary = Color(0xFFD65A31);
  static const Color _backgroundLight = Color(0xFFF7F7FA);
  static const Color _backgroundDark = Color(0xFF383E56);
  static final BorderRadius _borderRadius = BorderRadius.circular(8);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light().copyWith(
          primary: _primary,
          background: _backgroundLight,
        ),
        scaffoldBackgroundColor: _backgroundLight,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: const BorderSide(
              color: _primary,
            ),
          ),
        ),
        elevatedButtonTheme: _elevatedButtonTheme,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: _primary,
          brightness: Brightness.dark,
          background: _backgroundDark,
        ),
        scaffoldBackgroundColor: _backgroundDark,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: const BorderSide(
              color: _primary,
            ),
          ),
        ),
        elevatedButtonTheme: _elevatedButtonTheme,
      );

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
    ),
  );
}
