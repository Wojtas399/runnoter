import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/settings_mapper.dart';
import 'package:runnoter/domain/model/settings.dart';

void main() {
  test(
    'map theme mode from db, '
    'light mode from db should be mapped to light mode from domain',
    () {
      const dbThemeMode = firebase.ThemeMode.light;
      const expectedDomainThemeMode = ThemeMode.light;

      final domainThemeMode = mapThemeModeFromDb(dbThemeMode);

      expect(domainThemeMode, expectedDomainThemeMode);
    },
  );

  test(
    'map theme mode from db, '
    'dark mode from db should be mapped to dark mode from domain',
    () {
      const dbThemeMode = firebase.ThemeMode.dark;
      const expectedDomainThemeMode = ThemeMode.dark;

      final domainThemeMode = mapThemeModeFromDb(dbThemeMode);

      expect(domainThemeMode, expectedDomainThemeMode);
    },
  );

  test(
    'map theme mode from db, '
    'system mode from db should be mapped to system mode from domain',
    () {
      const dbThemeMode = firebase.ThemeMode.system;
      const expectedDomainThemeMode = ThemeMode.system;

      final domainThemeMode = mapThemeModeFromDb(dbThemeMode);

      expect(domainThemeMode, expectedDomainThemeMode);
    },
  );

  test(
    'map language from db, '
    'polish type from db should be mapped to polish type from domain',
    () {
      const dbLanguage = firebase.Language.polish;
      const expectedDomainLanguage = Language.polish;

      final domainLanguage = mapLanguageFromDb(dbLanguage);

      expect(domainLanguage, expectedDomainLanguage);
    },
  );

  test(
    'map language from db, '
    'english type from db should be mapped to english type from domain',
    () {
      const dbLanguage = firebase.Language.english;
      const expectedDomainLanguage = Language.english;

      final domainLanguage = mapLanguageFromDb(dbLanguage);

      expect(domainLanguage, expectedDomainLanguage);
    },
  );

  test(
    'map distance unit from db, '
    'kilometers type from db should be mapped to kilometers type from domain',
    () {
      const dbDistanceUnit = firebase.DistanceUnit.kilometers;
      const expectedDomainDistanceUnit = DistanceUnit.kilometers;

      final domainDistanceUnit = mapDistanceUnitFromDb(dbDistanceUnit);

      expect(domainDistanceUnit, expectedDomainDistanceUnit);
    },
  );

  test(
    'map distance unit from db, '
    'miles type from db should be mapped to miles type from domain',
    () {
      const dbDistanceUnit = firebase.DistanceUnit.miles;
      const expectedDomainDistanceUnit = DistanceUnit.miles;

      final domainDistanceUnit = mapDistanceUnitFromDb(dbDistanceUnit);

      expect(domainDistanceUnit, expectedDomainDistanceUnit);
    },
  );

  test(
    'map pace unit from db, '
    'minutes per kilometer type from db should be mapped to minutes per kilometer type from domain',
    () {
      const dbPaceUnit = firebase.PaceUnit.minutesPerKilometer;
      const expectedDomainPaceUnit = PaceUnit.minutesPerKilometer;

      final domainPaceUnit = mapPaceUnitFromDb(dbPaceUnit);

      expect(domainPaceUnit, expectedDomainPaceUnit);
    },
  );

  test(
    'map pace unit from db, '
    'minutes per mile type from db should be mapped to minutes per mile type from domain',
    () {
      const dbPaceUnit = firebase.PaceUnit.minutesPerMile;
      const expectedDomainPaceUnit = PaceUnit.minutesPerMile;

      final domainPaceUnit = mapPaceUnitFromDb(dbPaceUnit);

      expect(domainPaceUnit, expectedDomainPaceUnit);
    },
  );

  test(
    'map pace unit from db, '
    'kilometers per hour type from db should be mapped to kilometers per hour type from domain',
    () {
      const dbPaceUnit = firebase.PaceUnit.kilometersPerHour;
      const expectedDomainPaceUnit = PaceUnit.kilometersPerHour;

      final domainPaceUnit = mapPaceUnitFromDb(dbPaceUnit);

      expect(domainPaceUnit, expectedDomainPaceUnit);
    },
  );

  test(
    'map pace unit from db, '
    'miles per hour type from db should be mapped to miles per hour type from domain',
    () {
      const dbPaceUnit = firebase.PaceUnit.milesPerHour;
      const expectedDomainPaceUnit = PaceUnit.milesPerHour;

      final domainPaceUnit = mapPaceUnitFromDb(dbPaceUnit);

      expect(domainPaceUnit, expectedDomainPaceUnit);
    },
  );
}
