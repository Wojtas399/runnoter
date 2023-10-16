import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/ui/service/distance_unit_service.dart';

void main() {
  DistanceUnitService createService({
    DistanceUnit distanceUnit = DistanceUnit.kilometers,
  }) =>
      DistanceUnitService(
        distanceUnit: distanceUnit,
      );

  blocTest(
    'change unit, '
    'should update unit in state',
    build: () => createService(),
    act: (DistanceUnitService service) => service.changeUnit(
      DistanceUnit.miles,
    ),
    expect: () => [
      DistanceUnit.miles,
    ],
  );

  test(
    'convert from default, '
    'kilometers, '
    'should not change passed value',
    () {
      const double distanceInKm = 21.4;
      final service = createService();

      final double convertedDistance = service.convertFromDefault(distanceInKm);

      expect(convertedDistance, distanceInKm);
    },
  );

  test(
    'convert from default, '
    'miles, '
    'should convert passed value to miles and round it to 2 decimal places',
    () {
      const double distanceInKm = 21.4;
      const double expectedDistanceInMiles = distanceInKm * 0.621371192;
      final service = createService(
        distanceUnit: DistanceUnit.miles,
      );

      final double convertedDistance = service.convertFromDefault(distanceInKm);

      expect(convertedDistance, expectedDistanceInMiles);
    },
  );

  test(
    'convert to default, '
    'kilometers, '
    'should not change passed value',
    () {
      const double distanceInKm = 21.4;
      final service = createService();

      final double convertedDistance = service.convertToDefault(distanceInKm);

      expect(convertedDistance, distanceInKm);
    },
  );

  test(
    'convert to default, '
    'miles, '
    'should not change passed value',
    () {
      const double distanceInKm = 21.4;
      const double expectedDistanceInMiles = distanceInKm * 1.609344;
      final service = createService(
        distanceUnit: DistanceUnit.miles,
      );

      final double convertedDistance = service.convertToDefault(distanceInKm);

      expect(convertedDistance, expectedDistanceInMiles);
    },
  );
}
