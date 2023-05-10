import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/morning_measurement_repository_impl.dart';
import 'package:runnoter/domain/model/morning_measurement.dart';

import '../../mock/firebase/mock_firebase_morning_measurement_service.dart';
import '../../mock/presentation/service/mock_date_service.dart';
import '../../util/morning_measurement_creator.dart';

void main() {
  final dateService = MockDateService();
  final firebaseMorningMeasurementService =
      MockFirebaseMorningMeasurementService();
  late MorningMeasurementRepositoryImpl repository;
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 1, 1);

  MorningMeasurementRepositoryImpl createRepository({
    List<MorningMeasurement>? initialState,
  }) =>
      MorningMeasurementRepositoryImpl(
        dateService: dateService,
        firebaseMorningMeasurementService: firebaseMorningMeasurementService,
        initialState: initialState,
      );

  tearDown(() {
    reset(dateService);
    reset(firebaseMorningMeasurementService);
  });

  test(
    'get measurement by date, '
    'measurement exists in repository, '
    'should emit matching measurement',
    () {
      final MorningMeasurement expectedMorningMeasurement =
          createMorningMeasurement(date: date);
      repository = createRepository(
        initialState: [
          createMorningMeasurement(
            date: DateTime(2023, 2, 10),
          ),
          expectedMorningMeasurement,
        ],
      );
      when(
        () => dateService.areDatesTheSame(DateTime(2023, 2, 10), date),
      ).thenReturn(false);
      when(
        () => dateService.areDatesTheSame(date, date),
      ).thenReturn(true);

      final Stream<MorningMeasurement?> measurement$ =
          repository.getMeasurementByDate(
        date: date,
        userId: userId,
      );
      measurement$.listen((_) {});

      expect(
        measurement$,
        emitsInOrder(
          [expectedMorningMeasurement],
        ),
      );
    },
  );

  test(
    'get measurement by date, '
    'measurement does not exist in repository, '
    'should load measurement from firebase and should emit loaded measurement',
    () {
      final MorningMeasurement expectedMorningMeasurement = MorningMeasurement(
        date: date,
        restingHeartRate: 50,
        fastingWeight: 50.5,
      );
      final MorningMeasurementDto morningMeasurementDto = MorningMeasurementDto(
        date: date,
        restingHeartRate: 50,
        weight: 50.5,
      );
      firebaseMorningMeasurementService.mockLoadMeasurementByDate(
        morningMeasurementDto: morningMeasurementDto,
      );
      repository = createRepository(
        initialState: [
          createMorningMeasurement(
            date: DateTime(2023, 2, 10),
          ),
        ],
      );
      when(
        () => dateService.areDatesTheSame(DateTime(2023, 2, 10), date),
      ).thenReturn(false);
      when(
        () => dateService.areDatesTheSame(date, date),
      ).thenReturn(true);

      final Stream<MorningMeasurement?> measurement$ =
          repository.getMeasurementByDate(
        date: date,
        userId: userId,
      );
      measurement$.listen((_) {});

      expect(
        measurement$,
        emitsInOrder(
          [
            null,
            expectedMorningMeasurement,
          ],
        ),
      );
    },
  );

  test(
    'add measurement, '
    "should call firebase service's method to add measurement and should add this new measurement to repo state",
    () {
      const int restingHeartRate = 55;
      const double fastingWeight = 55.5;
      final MorningMeasurement morningMeasurement = MorningMeasurement(
        date: date,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );
      final MorningMeasurementDto morningMeasurementDto = MorningMeasurementDto(
        date: date,
        restingHeartRate: restingHeartRate,
        weight: fastingWeight,
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
