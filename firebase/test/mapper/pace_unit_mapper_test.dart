import 'package:firebase/firebase.dart';
import 'package:firebase/mapper/pace_unit_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map pace unit from string to enum, '
    'minutes per kilometer should be mapped to PaceUnit.minutesPerKilometer',
    () {
      const String strPaceUnit = 'minutesPerKilometer';
      const PaceUnit expectedEnumPaceUnit = PaceUnit.minutesPerKilometer;

      final PaceUnit enumPaceUnit = mapPaceUnitFromStringToEnum(strPaceUnit);

      expect(enumPaceUnit, expectedEnumPaceUnit);
    },
  );

  test(
    'map pace unit from string to enum, '
    'minutes per mile should be mapped to PaceUnit.minutesPerMile',
    () {
      const String strPaceUnit = 'minutesPerMile';
      const PaceUnit expectedEnumPaceUnit = PaceUnit.minutesPerMile;

      final PaceUnit enumPaceUnit = mapPaceUnitFromStringToEnum(strPaceUnit);

      expect(enumPaceUnit, expectedEnumPaceUnit);
    },
  );

  test(
    'map pace unit from string to enum, '
    'kilometers per hour should be mapped to PaceUnit.kilometersPerHour',
    () {
      const String strPaceUnit = 'kilometersPerHour';
      const PaceUnit expectedEnumPaceUnit = PaceUnit.kilometersPerHour;

      final PaceUnit enumPaceUnit = mapPaceUnitFromStringToEnum(strPaceUnit);

      expect(enumPaceUnit, expectedEnumPaceUnit);
    },
  );

  test(
    'map pace unit from string to enum, '
    'miles per hour should be mapped to PaceUnit.milesPerHour',
    () {
      const String strPaceUnit = 'milesPerHour';
      const PaceUnit expectedEnumPaceUnit = PaceUnit.milesPerHour;

      final PaceUnit enumPaceUnit = mapPaceUnitFromStringToEnum(strPaceUnit);

      expect(enumPaceUnit, expectedEnumPaceUnit);
    },
  );
}
