import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String userId = 'u1';
  const ThemeMode themeMode = ThemeMode.dark;
  const Language language = Language.english;
  const AppearanceSettingsDto appearanceSettingsDto = AppearanceSettingsDto(
    userId: userId,
    themeMode: themeMode,
    language: language,
  );
  final Map<String, dynamic> appearanceSettingsJson = {
    'themeMode': themeMode.name,
    'language': language.name,
  };

  test(
    'from json, '
    'should map json to dto model',
    () {
      final AppearanceSettingsDto dto = AppearanceSettingsDto.fromJson(
        userId,
        appearanceSettingsJson,
      );

      expect(dto, appearanceSettingsDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final Map<String, dynamic> json = appearanceSettingsDto.toJson();

      expect(json, appearanceSettingsJson);
    },
  );

  test(
    'create json to update, '
    'theme mode is null, '
    'should not include theme mode in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'language': language.name,
      };

      final Map<String, dynamic> json = createAppearanceSettingsJsonToUpdate(
        language: language,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'language is null, '
    'should not include language in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'themeMode': themeMode.name,
      };

      final Map<String, dynamic> json = createAppearanceSettingsJsonToUpdate(
        themeMode: themeMode,
      );

      expect(json, expectedJson);
    },
  );
}
