import 'package:firebase/firebase.dart' as db;

import '../../domain/model/settings.dart';

Settings mapSettingsFromDb({
  required db.AppearanceSettingsDto appearanceSettingsDto,
  required db.WorkoutSettingsDto workoutSettingsDto,
}) {
  return Settings(
    themeMode: mapThemeModeFromDb(appearanceSettingsDto.themeMode),
    language: mapLanguageFromDb(appearanceSettingsDto.language),
    distanceUnit: mapDistanceUnitFromDb(workoutSettingsDto.distanceUnit),
    paceUnit: mapPaceUnitFromDb(workoutSettingsDto.paceUnit),
  );
}

ThemeMode mapThemeModeFromDb(db.ThemeMode dbThemeMode) {
  switch (dbThemeMode) {
    case db.ThemeMode.dark:
      return ThemeMode.dark;
    case db.ThemeMode.light:
      return ThemeMode.light;
    case db.ThemeMode.system:
      return ThemeMode.system;
  }
}

Language mapLanguageFromDb(db.Language dbLanguage) {
  switch (dbLanguage) {
    case db.Language.polish:
      return Language.polish;
    case db.Language.english:
      return Language.english;
  }
}

DistanceUnit mapDistanceUnitFromDb(db.DistanceUnit dbDistanceUnit) {
  switch (dbDistanceUnit) {
    case db.DistanceUnit.kilometers:
      return DistanceUnit.kilometers;
    case db.DistanceUnit.miles:
      return DistanceUnit.miles;
  }
}

PaceUnit mapPaceUnitFromDb(db.PaceUnit dbPaceUnit) {
  switch (dbPaceUnit) {
    case db.PaceUnit.minutesPerKilometer:
      return PaceUnit.minutesPerKilometer;
    case db.PaceUnit.minutesPerMile:
      return PaceUnit.minutesPerMile;
    case db.PaceUnit.kilometersPerHour:
      return PaceUnit.kilometersPerHour;
    case db.PaceUnit.milesPerHour:
      return PaceUnit.milesPerHour;
  }
}
