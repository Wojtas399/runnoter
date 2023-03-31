import '../firebase.dart';

ThemeMode mapThemeModeFromStringToEnum(String themeMode) {
  return ThemeMode.values.byName(themeMode);
}
