import 'package:firebase/firebase.dart' as db;

import '../../domain/model/settings.dart';

Settings mapSettingsFromDto({
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

db.ThemeMode mapThemeModeToDb(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.dark:
      return db.ThemeMode.dark;
    case ThemeMode.light:
      return db.ThemeMode.light;
    case ThemeMode.system:
      return db.ThemeMode.system;
  }
}

Language mapLanguageFromDb(db.Language dbLanguage) {
  switch (dbLanguage) {
    case db.Language.polish:
      return Language.polish;
    case db.Language.english:
      return Language.english;
    case db.Language.system:
      return Language.system;
  }
}

db.Language mapLanguageToDb(Language language) {
  switch (language) {
    case Language.polish:
      return db.Language.polish;
    case Language.english:
      return db.Language.english;
    case Language.system:
      return db.Language.system;
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

db.DistanceUnit mapDistanceUnitToDb(DistanceUnit distanceUnit) {
  switch (distanceUnit) {
    case DistanceUnit.kilometers:
      return db.DistanceUnit.kilometers;
    case DistanceUnit.miles:
      return db.DistanceUnit.miles;
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

db.PaceUnit mapPaceUnitToDb(PaceUnit paceUnit) {
  switch (paceUnit) {
    case PaceUnit.minutesPerKilometer:
      return db.PaceUnit.minutesPerKilometer;
    case PaceUnit.minutesPerMile:
      return db.PaceUnit.minutesPerMile;
    case PaceUnit.kilometersPerHour:
      return db.PaceUnit.kilometersPerHour;
    case PaceUnit.milesPerHour:
      return db.PaceUnit.milesPerHour;
  }
}
