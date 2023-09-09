part of 'profile_settings_cubit.dart';

class ProfileSettingsState extends Equatable {
  final ThemeMode? themeMode;
  final Language? language;
  final DistanceUnit? distanceUnit;
  final PaceUnit? paceUnit;

  const ProfileSettingsState({
    this.themeMode,
    this.language,
    this.distanceUnit,
    this.paceUnit,
  });

  @override
  List<Object?> get props => [themeMode, language, distanceUnit, paceUnit];

  ProfileSettingsState copyWith({
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  }) {
    return ProfileSettingsState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      paceUnit: paceUnit ?? this.paceUnit,
    );
  }
}
