import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/service/distance_unit_service.dart';

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
    'convert distance, '
    'kilometers, '
    'should not change passed value',
    () {
      const double distanceInKm = 21.4;
      final service = createService();

      final double convertedDistance = service.convertDistance(distanceInKm);

      expect(convertedDistance, distanceInKm);
    },
  );

  test(
    'convert distance, '
    'miles, '
    'should convert passed value to miles and round it to 2 decimal places',
    () {
      const double distanceInKm = 21.4;
      final double expectedDistanceInMiles = double.parse(
        (distanceInKm * 0.621371192).toStringAsFixed(2),
      );
      final service = createService(
        distanceUnit: DistanceUnit.miles,
      );

      final double convertedDistance = service.convertDistance(distanceInKm);

      expect(convertedDistance, expectedDistanceInMiles);
    },
  );
}
