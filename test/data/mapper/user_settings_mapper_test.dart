import 'package:firebase/firebase.dart' as db;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/data/mapper/user_settings_mapper.dart';

void main() {
  test(
    'map theme mode from db, '
    'light mode from db should be mapped to light mode from domain',
    () {
      const dbThemeMode = db.ThemeMode.light;
      const expectedThemeMode = ThemeMode.light;

      final themeMode = mapThemeModeFromDb(dbThemeMode);

      expect(themeMode, expectedThemeMode);
    },
  );

  test(
    'map theme mode from db, '
    'dark mode from db should be mapped to dark mode from domain',
    () {
      const dbThemeMode = db.ThemeMode.dark;
      const expectedThemeMode = ThemeMode.dark;

      final themeMode = mapThemeModeFromDb(dbThemeMode);

      expect(themeMode, expectedThemeMode);
    },
  );

  test(
    'map theme mode from db, '
    'system mode from db should be mapped to system mode from domain',
    () {
      const dbThemeMode = db.ThemeMode.system;
      const expectedThemeMode = ThemeMode.system;

      final themeMode = mapThemeModeFromDb(dbThemeMode);

      expect(themeMode, expectedThemeMode);
    },
  );

  test(
    'map theme mode to db, '
    'light mode from domain should be mapped to light mode from db',
    () {
      const themeMode = ThemeMode.light;
      const expectedDbThemeMode = db.ThemeMode.light;

      final dbThemeMode = mapThemeModeToDb(themeMode);

      expect(dbThemeMode, expectedDbThemeMode);
    },
  );

  test(
    'map theme mode to db, '
    'dark mode from domain should be mapped to dark mode from db',
    () {
      const themeMode = ThemeMode.dark;
      const expectedDbThemeMode = db.ThemeMode.dark;

      final dbThemeMode = mapThemeModeToDb(themeMode);

      expect(dbThemeMode, expectedDbThemeMode);
    },
  );

  test(
    'map theme mode to db, '
    'system mode from domain should be mapped to system mode from db',
    () {
      const themeMode = ThemeMode.system;
      const expectedDbThemeMode = db.ThemeMode.system;

      final dbThemeMode = mapThemeModeToDb(themeMode);

      expect(dbThemeMode, expectedDbThemeMode);
    },
  );

  test(
    'map language from db, '
    'polish type from db should be mapped to polish type from domain',
    () {
      const dbLanguage = db.Language.polish;
      const expectedDomainLanguage = Language.polish;

      final domainLanguage = mapLanguageFromDb(dbLanguage);

      expect(domainLanguage, expectedDomainLanguage);
    },
  );

  test(
    'map language from db, '
    'english type from db should be mapped to english type from domain',
    () {
      const dbLanguage = db.Language.english;
      const expectedDomainLanguage = Language.english;

      final domainLanguage = mapLanguageFromDb(dbLanguage);

      expect(domainLanguage, expectedDomainLanguage);
    },
  );

  test(
    'map language from db, '
    'system type from db should be mapped to system type from domain',
    () {
      const dbLanguage = db.Language.system;
      const expectedDomainLanguage = Language.system;

      final domainLanguage = mapLanguageFromDb(dbLanguage);

      expect(domainLanguage, expectedDomainLanguage);
    },
  );

  test(
    'map language to db, '
    'polish type from domain should be mapped to polish type from db',
    () {
      const language = Language.polish;
      const expectedDbLanguage = db.Language.polish;

      final dbLanguage = mapLanguageToDb(language);

      expect(dbLanguage, expectedDbLanguage);
    },
  );

  test(
    'map language to db, '
    'english type from domain should be mapped to english type from db',
    () {
      const language = Language.english;
      const expectedDbLanguage = db.Language.english;

      final dbLanguage = mapLanguageToDb(language);

      expect(dbLanguage, expectedDbLanguage);
    },
  );

  test(
    'map language to db, '
    'system type from domain should be mapped to system type from db',
    () {
      const language = Language.system;
      const expectedDbLanguage = db.Language.system;

      final dbLanguage = mapLanguageToDb(language);

      expect(dbLanguage, expectedDbLanguage);
    },
  );

  test(
    'map distance unit from db, '
    'kilometers type from db should be mapped to kilometers type from domain',
    () {
      const dbDistanceUnit = db.DistanceUnit.kilometers;
      const expectedDomainDistanceUnit = DistanceUnit.kilometers;

      final domainDistanceUnit = mapDistanceUnitFromDb(dbDistanceUnit);

      expect(domainDistanceUnit, expectedDomainDistanceUnit);
    },
  );

  test(
    'map distance unit from db, '
    'miles type from db should be mapped to miles type from domain',
    () {
      const dbDistanceUnit = db.DistanceUnit.miles;
      const expectedDomainDistanceUnit = DistanceUnit.miles;

      final domainDistanceUnit = mapDistanceUnitFromDb(dbDistanceUnit);

      expect(domainDistanceUnit, expectedDomainDistanceUnit);
    },
  );

  test(
    'map distance unit to db, '
    'kilometers type from domain should be mapped to kilometers type from db',
    () {
      const distanceUnit = DistanceUnit.kilometers;
      const expectedDbDistanceUnit = db.DistanceUnit.kilometers;

      final dbDistanceUnit = mapDistanceUnitToDb(distanceUnit);

      expect(dbDistanceUnit, expectedDbDistanceUnit);
    },
  );

  test(
    'map distance unit to db, '
    'miles type from domain should be mapped to miles type from db',
    () {
      const distanceUnit = DistanceUnit.kilometers;
      const expectedDbDistanceUnit = db.DistanceUnit.kilometers;

      final dbDistanceUnit = mapDistanceUnitToDb(distanceUnit);

      expect(dbDistanceUnit, expectedDbDistanceUnit);
    },
  );

  test(
    'map pace unit from db, '
    'minutes per kilometer type from db should be mapped to minutes per kilometer type from domain',
    () {
      const dbPaceUnit = db.PaceUnit.minutesPerKilometer;
      const expectedDomainPaceUnit = PaceUnit.minutesPerKilometer;

      final domainPaceUnit = mapPaceUnitFromDb(dbPaceUnit);

      expect(domainPaceUnit, expectedDomainPaceUnit);
    },
  );

  test(
    'map pace unit from db, '
    'minutes per mile type from db should be mapped to minutes per mile type from domain',
    () {
      const dbPaceUnit = db.PaceUnit.minutesPerMile;
      const expectedDomainPaceUnit = PaceUnit.minutesPerMile;

      final domainPaceUnit = mapPaceUnitFromDb(dbPaceUnit);

      expect(domainPaceUnit, expectedDomainPaceUnit);
    },
  );

  test(
    'map pace unit from db, '
    'kilometers per hour type from db should be mapped to kilometers per hour type from domain',
    () {
      const dbPaceUnit = db.PaceUnit.kilometersPerHour;
      const expectedDomainPaceUnit = PaceUnit.kilometersPerHour;

      final domainPaceUnit = mapPaceUnitFromDb(dbPaceUnit);

      expect(domainPaceUnit, expectedDomainPaceUnit);
    },
  );

  test(
    'map pace unit from db, '
    'miles per hour type from db should be mapped to miles per hour type from domain',
    () {
      const dbPaceUnit = db.PaceUnit.milesPerHour;
      const expectedDomainPaceUnit = PaceUnit.milesPerHour;

      final domainPaceUnit = mapPaceUnitFromDb(dbPaceUnit);

      expect(domainPaceUnit, expectedDomainPaceUnit);
    },
  );

  test(
    'map pace unit to db, '
    'minutes per kilometer type from domain should be mapped to minutes per kilometer type from db',
    () {
      const paceUnit = PaceUnit.minutesPerKilometer;
      const expectedDbPaceUnit = db.PaceUnit.minutesPerKilometer;

      final dbPaceUnit = mapPaceUnitToDb(paceUnit);

      expect(dbPaceUnit, expectedDbPaceUnit);
    },
  );

  test(
    'map pace unit to db, '
    'minutes per mile type from domain should be mapped to minutes per mile type from db',
    () {
      const paceUnit = PaceUnit.minutesPerMile;
      const expectedDbPaceUnit = db.PaceUnit.minutesPerMile;

      final dbPaceUnit = mapPaceUnitToDb(paceUnit);

      expect(dbPaceUnit, expectedDbPaceUnit);
    },
  );

  test(
    'map pace unit to db, '
    'kilometers per hour type from domain should be mapped to kilometers per hour type from db',
    () {
      const paceUnit = PaceUnit.kilometersPerHour;
      const expectedDbPaceUnit = db.PaceUnit.kilometersPerHour;

      final dbPaceUnit = mapPaceUnitToDb(paceUnit);

      expect(dbPaceUnit, expectedDbPaceUnit);
    },
  );

  test(
    'map pace unit to db, '
    'miles per hour type from domain should be mapped to miles per hour type from db',
    () {
      const paceUnit = PaceUnit.milesPerHour;
      const expectedDbPaceUnit = db.PaceUnit.milesPerHour;

      final dbPaceUnit = mapPaceUnitToDb(paceUnit);

      expect(dbPaceUnit, expectedDbPaceUnit);
    },
  );
}
