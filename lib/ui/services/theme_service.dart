import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeService extends Cubit<ThemeMode> {
  ThemeService() : super(ThemeMode.light);

  void turnOnLightTheme() {
    emit(ThemeMode.light);
  }

  void turnOnDarkTheme() {
    emit(ThemeMode.dark);
  }

  void turnOnSystemTheme() {
    emit(ThemeMode.system);
  }
}
