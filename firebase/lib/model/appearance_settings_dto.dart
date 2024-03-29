import 'package:equatable/equatable.dart';

import '../mapper/language_mapper.dart';
import '../mapper/theme_mode_mapper.dart';

class AppearanceSettingsDto extends Equatable {
  final String userId;
  final ThemeMode themeMode;
  final Language language;

  const AppearanceSettingsDto({
    required this.userId,
    required this.themeMode,
    required this.language,
  });

  @override
  List<Object> get props => [
        userId,
        themeMode,
        language,
      ];

  AppearanceSettingsDto.fromJson({
    required String userId,
    required Map<String, dynamic>? json,
  }) : this(
          userId: userId,
          themeMode: mapThemeModeFromStringToEnum(
            json?[_AppearanceSettingsFields.themeMode.name],
          ),
          language: mapLanguageFromStringToEnum(
            json?[_AppearanceSettingsFields.language.name],
          ),
        );

  Map<String, Object?> toJson() {
    return {
      _AppearanceSettingsFields.themeMode.name: themeMode.name,
      _AppearanceSettingsFields.language.name: language.name,
    };
  }
}

enum ThemeMode {
  dark,
  light,
  system;
}

enum Language {
  polish,
  english,
  system,
}

Map<String, dynamic> createAppearanceSettingsJsonToUpdate({
  ThemeMode? themeMode,
  Language? language,
}) =>
    {
      if (themeMode != null)
        _AppearanceSettingsFields.themeMode.name: themeMode.name,
      if (language != null)
        _AppearanceSettingsFields.language.name: language.name,
    };

enum _AppearanceSettingsFields {
  themeMode,
  language,
}
