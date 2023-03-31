part of firebase;

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

  AppearanceSettingsDto.fromJson(
    String userId,
    Map<String, dynamic>? json,
  ) : this(
          userId: userId,
          themeMode: mapThemeModeFromStringToEnum(
            json?[_AppearanceSettingsFields.themeMode],
          ),
          language: mapLanguageFromStringToEnum(
            json?[_AppearanceSettingsFields.language],
          ),
        );

  Map<String, Object?> toJson() {
    return {
      _AppearanceSettingsFields.themeMode: themeMode.name,
      _AppearanceSettingsFields.language: language.name,
    };
  }
}

class _AppearanceSettingsFields {
  static const String themeMode = 'themeMode';
  static const String language = 'language';
}
