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
        fastingWeight: 50.5,
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
    'get measurements by date range, '
    'should emit existing and matching measurements, should load new measurements from firebase and should also emit newly loaded measurements',
    () {
      final DateTime startDate = DateTime(2023, 1, 1);
      final DateTime endDate = DateTime(2023, 1, 7);

      void mockIsDateFromRange(DateTime date, bool expected) {
        when(
          () => dateService.isDateFromRange(
            date: date,
            startDate: startDate,
            endDate: endDate,
          ),
        ).thenReturn(expected);
      }

      final List<MorningMeasurement> existingMeasurements = [
        MorningMeasurement(
          date: DateTime(2023, 1, 2),
          restingHeartRate: 50,
          fastingWeight: 50.5,
        ),
        MorningMeasurement(
          date: DateTime(2023, 1, 3),
          restingHeartRate: 53,
          fastingWeight: 51.5,
        ),
        MorningMeasurement(
          date: DateTime(2023, 1, 8),
          restingHeartRate: 50,
          fastingWeight: 50.8,
        ),
      ];
      final List<MorningMeasurementDto> loadedMeasurementDtos = [
        MorningMeasurementDto(
          date: DateTime(2023, 1, 5),
          restingHeartRate: 49,
          fastingWeight: 52.4,
        ),
        MorningMeasurementDto(
          date: DateTime(2023, 1, 6),
          restingHeartRate: 49,
          fastingWeight: 52.8,
        ),
      ];
      final List<MorningMeasurement> loadedMeasurements = [
        MorningMeasurement(
          date: DateTime(2023, 1, 5),
          restingHeartRate: 49,
          fastingWeight: 52.4,
        ),
        MorningMeasurement(
          date: DateTime(2023, 1, 6),
          restingHeartRate: 49,
          fastingWeight: 52.8,
        ),
      ];
      mockIsDateFromRange(DateTime(2023, 1, 2), true);
      mockIsDateFromRange(DateTime(2023, 1, 3), true);
      mockIsDateFromRange(DateTime(2023, 1, 8), false);
      mockIsDateFromRange(DateTime(2023, 1, 5), true);
      mockIsDateFromRange(DateTime(2023, 1, 6), true);
      firebaseMorningMeasurementService.mockLoadMeasurementsByDateRange(
        morningMeasurementDtos: loadedMeasurementDtos,
      );
      repository = createRepository(initialState: existingMeasurements);

      Stream<List<MorningMeasurement>?> measurements$ =
          repository.getMeasurementsByDateRange(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      );
      measurements$.listen((_) {});

      expect(
        measurements$,
        emitsInOrder(
          [
            [
              existingMeasurements[0],
              existingMeasurements[1],
            ],
            [
              existingMeasurements[0],
              existingMeasurements[1],
              ...loadedMeasurements,
            ],
          ],
        ),
      );
      verify(
        () => firebaseMorningMeasurementService.loadMeasurementsByDateRange(
          startDate: startDate,
          endDate: endDate,
          userId: userId,
        ),
      ).called(1);
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
        fastingWeight: fastingWeight,
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
