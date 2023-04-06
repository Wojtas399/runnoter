import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:runnoter/presentation/service/theme_service.dart';

void main() {
  ThemeService createThemeService() => ThemeService();

  blocTest(
    'change theme mode, '
    'should update theme mode in state',
    build: () => createThemeService(),
    act: (ThemeService service) {
      service.changeTheme(ThemeMode.dark);
    },
    expect: () => [
      ThemeMode.dark,
    ],
  );
}
