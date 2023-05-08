import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/morning_measurement_repository_impl.dart';
import 'package:runnoter/domain/model/morning_measurement.dart';

import '../../mock/firebase/mock_firebase_morning_measurement_service.dart';

void main() {
  final firebaseMorningMeasurementService =
      MockFirebaseMorningMeasurementService();
  late MorningMeasurementRepositoryImpl repository;

  MorningMeasurementRepositoryImpl createRepository() =>
      MorningMeasurementRepositoryImpl(
        firebaseMorningMeasurementService: firebaseMorningMeasurementService,
      );

  test(
    'add measurement, '
    "should call firebase service's method to add measurement and should add this new measurement to repo state",
    () {
      const String userId = 'u1';
      final DateTime date = DateTime(2023, 1, 1);
      const int restingHeartRate = 55;
      const double weight = 55.5;
      final MorningMeasurement morningMeasurement = MorningMeasurement(
        date: date,
        restingHeartRate: restingHeartRate,
        weight: weight,
      );
      final MorningMeasurementDto morningMeasurementDto = MorningMeasurementDto(
        date: date,
        restingHeartRate: restingHeartRate,
        weight: weight,
      );
      firebaseMorningMeasurementService.mockAddMeasurement(
        addedMeasurementDto: morningMeasurementDto,
      );
      repository = createRepository();

      final Stream<List<MorningMeasurement>?> state$ = repository.dataStream$;
      repository.addMeasurement(
        userId: userId,
        measurement: morningMeasurement,
      );

      expect(
        state$,
        emitsInOrder(
          [
            null,
            [morningMeasurement]
          ],
        ),
      );
      verify(
        () => firebaseMorningMeasurementService.addMeasurement(
          userId: userId,
          measurementDto: morningMeasurementDto,
        ),
      ).called(1);
    },
  );
}
