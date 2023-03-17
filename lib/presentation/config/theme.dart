import 'package:flutter/material.dart';

class GlobalTheme {
  static const Color _primary = Color(0xFFD65A31);
  static const Color _backgroundLight = Color(0xFFF7F7FA);
  static const Color _backgroundDark = Color(0xFF383E56);
  static const Color _itemBackgroundDark = Color(0xFF2A2831);
  static final Color _outlineLight = Colors.white.withOpacity(0.5);
  static final Color _outlineDark = Colors.black.withOpacity(0.5);
  static final BorderRadius _borderRadius = BorderRadius.circular(8);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light().copyWith(
          primary: _primary,
          background: _backgroundLight,
          outline: _outlineDark,
        ),
        scaffoldBackgroundColor: _backgroundLight,
        inputDecorationTheme: _inputDecoration.copyWith(
          prefixIconColor: _outlineDark,
          suffixIconColor: _outlineDark,
          enabledBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: BorderSide(
              color: _outlineDark,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: BorderSide(
              color: const ColorScheme.light().error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: BorderSide(
              color: const ColorScheme.light().error,
            ),
          ),
        ),
        elevatedButtonTheme: _elevatedButtonTheme,
        dialogTheme: _dialogTheme.copyWith(
          backgroundColor: _backgroundLight,
          surfaceTintColor: _backgroundLight,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: _primary,
          brightness: Brightness.dark,
          background: _backgroundDark,
          outline: _outlineLight,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _itemBackgroundDark,
        ),
        scaffoldBackgroundColor: _backgroundDark,
        inputDecorationTheme: _inputDecoration.copyWith(
          prefixIconColor: _outlineLight,
          suffixIconColor: _outlineLight,
          enabledBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: BorderSide(
              color: _outlineLight,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: BorderSide(
              color: const ColorScheme.dark().error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: BorderSide(
              color: const ColorScheme.dark().error,
            ),
          ),
        ),
        elevatedButtonTheme: _elevatedButtonTheme,
        dialogTheme: _dialogTheme.copyWith(
          backgroundColor: _backgroundDark,
          surfaceTintColor: _backgroundDark,
        ),
      );

  static final InputDecorationTheme _inputDecoration = InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: const BorderSide(
        color: _primary,
      ),
    ),
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
    ),
  );

  static final DialogTheme _dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: _borderRadius,
    ),
    actionsPadding: const EdgeInsets.all(16),
  );
}
