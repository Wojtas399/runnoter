import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String userId = 'u1';
  const ThemeMode themeMode = ThemeMode.dark;
  const Language language = Language.english;

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'themeMode': themeMode.name,
        'language': language.name,
      };
      const AppearanceSettingsDto expectedDto = AppearanceSettingsDto(
        userId: userId,
        themeMode: themeMode,
        language: language,
      );

      final AppearanceSettingsDto dto =
          AppearanceSettingsDto.fromJson(userId, json);

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      const AppearanceSettingsDto dto = AppearanceSettingsDto(
        userId: userId,
        themeMode: themeMode,
        language: language,
      );
      final Map<String, dynamic> expectedJson = {
        'themeMode': themeMode.name,
        'language': language.name,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
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
