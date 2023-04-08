import 'package:firebase/firebase.dart';
import 'package:firebase/mapper/theme_mode_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map theme mode from string to enum, '
    'dark should be mapped to ThemeMode.dark',
    () {
      const String strThemeMode = 'dark';
      const ThemeMode expectedEnumThemeMode = ThemeMode.dark;

      final ThemeMode enumThemeMode = mapThemeModeFromStringToEnum(
        strThemeMode,
      );

      expect(enumThemeMode, expectedEnumThemeMode);
    },
  );

  test(
    'map theme mode from string to enum, '
    'light should be mapped to ThemeMode.light',
    () {
      const String strThemeMode = 'light';
      const ThemeMode expectedEnumThemeMode = ThemeMode.light;

      final ThemeMode enumThemeMode = mapThemeModeFromStringToEnum(
        strThemeMode,
      );

      expect(enumThemeMode, expectedEnumThemeMode);
    },
  );

  test(
    'map theme mode from string to enum, '
    'system dark should be mapped to ThemeMode.system',
    () {
      const String strThemeMode = 'system';
      const ThemeMode expectedEnumThemeMode = ThemeMode.system;

      final ThemeMode enumThemeMode = mapThemeModeFromStringToEnum(
        strThemeMode,
      );

      expect(enumThemeMode, expectedEnumThemeMode);
    },
  );
}
