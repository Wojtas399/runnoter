import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeService extends Cubit<ThemeMode> {
  ThemeService() : super(ThemeMode.system);

  void changeTheme(ThemeMode themeMode) {
    emit(themeMode);
  }
}
