import 'package:firebase/firebase.dart';
import 'package:firebase/mapper/distance_unit_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map distance unit from string to enum, '
    'kilometers should be mapped to DistanceUnit.kilometers',
    () {
      const String strDistanceUnit = 'kilometers';
      const DistanceUnit expectedEnumDistanceUnit = DistanceUnit.kilometers;

      final DistanceUnit enumDistanceUnit = mapDistanceUnitFromStringToEnum(
        strDistanceUnit,
      );

      expect(enumDistanceUnit, expectedEnumDistanceUnit);
    },
  );

  test(
    'map distance unit from string to enum, '
    'miles should be mapped to DistanceUnit.miles',
    () {
      const String strDistanceUnit = 'miles';
      const DistanceUnit expectedEnumDistanceUnit = DistanceUnit.miles;

      final DistanceUnit enumDistanceUnit = mapDistanceUnitFromStringToEnum(
        strDistanceUnit,
      );

      expect(enumDistanceUnit, expectedEnumDistanceUnit);
    },
  );
}
