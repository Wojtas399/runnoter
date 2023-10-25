import 'package:firebase/firebase.dart';

AppearanceSettingsDto createAppearanceSettingsDto({
  String userId = '',
  ThemeMode themeMode = ThemeMode.light,
  Language language = Language.polish,
}) =>
    AppearanceSettingsDto(
      userId: userId,
      themeMode: themeMode,
      language: language,
    );
