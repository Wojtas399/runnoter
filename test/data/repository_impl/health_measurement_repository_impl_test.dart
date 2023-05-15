import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/health_measurement_repository_impl.dart';
import 'package:runnoter/domain/model/health_measurement.dart';

import '../../mock/firebase/mock_firebase_health_measurement_service.dart';
import '../../mock/presentation/service/mock_date_service.dart';
import '../../util/health_measurement_creator.dart';

void main() {
  final dateService = MockDateService();
  final firebaseHealthMeasurementService =
      MockFirebaseHealthMeasurementService();
  late HealthMeasurementRepositoryImpl repository;
  const String userId = 'u1';

  HealthMeasurementRepositoryImpl createRepository({
    List<HealthMeasurement>? initialState,
  }) =>
      HealthMeasurementRepositoryImpl(
        dateService: dateService,
        firebaseHealthMeasurementService: firebaseHealthMeasurementService,
        initialState: initialState,
      );

  tearDown(() {
    reset(dateService);
    reset(firebaseHealthMeasurementService);
  });

  test(
    'get measurement by date, '
    'measurement exists in repository, '
    'should emit matching measurement',
    () {
      final DateTime date = DateTime(2023, 2, 9);
      final HealthMeasurement expectedHealthMeasurement =
          createHealthMeasurement(
        date: date,
        userId: userId,
      );
      repository = createRepository(
        initialState: [
          createHealthMeasurement(
            date: DateTime(2023, 2, 10),
            userId: userId,
          ),
          createHealthMeasurement(
            date: date,
            userId: 'u2',
          ),
          expectedHealthMeasurement,
        ],
      );
      when(
        () => dateService.areDatesTheSame(DateTime(2023, 2, 10), date),
      ).thenReturn(false);
      when(
        () => dateService.areDatesTheSame(date, date),
      ).thenReturn(true);

      final Stream<HealthMeasurement?> measurement$ =
          repository.getMeasurementByDate(
        date: date,
        userId: userId,
      );
      measurement$.listen((_) {});

      expect(
        measurement$,
        emitsInOrder(
          [expectedHealthMeasurement],
        ),
      );
    },
  );

  test(
    'get measurement by date, '
    'measurement does not exist in repository, '
    'should load measurement from firebase and should emit loaded measurement',
    () {
      final DateTime date = DateTime(2023, 2, 9);
      final HealthMeasurement expectedHealthMeasurement = HealthMeasurement(
        userId: userId,
        date: date,
        restingHeartRate: 50,
        fastingWeight: 50.5,
      );
      final HealthMeasurementDto healthMeasurementDto = HealthMeasurementDto(
        userId: userId,
        date: date,
        restingHeartRate: 50,
        fastingWeight: 50.5,
      );
      firebaseHealthMeasurementService.mockLoadMeasurementByDate(
        healthMeasurementDto: healthMeasurementDto,
      );
      repository = createRepository(
        initialState: [
          createHealthMeasurement(
            date: DateTime(2023, 2, 10),
            userId: userId,
          ),
          createHealthMeasurement(
            date: date,
            userId: 'u2',
          ),
        ],
      );
      when(
        () => dateService.areDatesTheSame(DateTime(2023, 2, 10), date),
      ).thenReturn(false);
      when(
        () => dateService.areDatesTheSame(date, date),
      ).thenReturn(true);

      final Stream<HealthMeasurement?> measurement$ =
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
            expectedHealthMeasurement,
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

      final List<HealthMeasurement> existingMeasurements = [
        HealthMeasurement(
          userId: userId,
          date: DateTime(2023, 1, 2),
          restingHeartRate: 50,
          fastingWeight: 50.5,
        ),
        HealthMeasurement(
          userId: 'u2',
          date: DateTime(2023, 1, 3),
          restingHeartRate: 53,
          fastingWeight: 51.5,
        ),
        HealthMeasurement(
          userId: userId,
          date: DateTime(2023, 1, 8),
          restingHeartRate: 50,
          fastingWeight: 50.8,
        ),
      ];
      final List<HealthMeasurementDto> loadedMeasurementDtos = [
        HealthMeasurementDto(
          userId: userId,
          date: DateTime(2023, 1, 5),
          restingHeartRate: 49,
          fastingWeight: 52.4,
        ),
        HealthMeasurementDto(
          userId: userId,
          date: DateTime(2023, 1, 6),
          restingHeartRate: 49,
          fastingWeight: 52.8,
        ),
      ];
      final List<HealthMeasurement> loadedMeasurements = [
        HealthMeasurement(
          userId: userId,
          date: DateTime(2023, 1, 5),
          restingHeartRate: 49,
          fastingWeight: 52.4,
        ),
        HealthMeasurement(
          userId: userId,
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
      firebaseHealthMeasurementService.mockLoadMeasurementsByDateRange(
        healthMeasurementDtos: loadedMeasurementDtos,
      );
      repository = createRepository(initialState: existingMeasurements);

      Stream<List<HealthMeasurement>?> measurements$ =
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
            ],
            [
              existingMeasurements[0],
              ...loadedMeasurements,
            ],
          ],
        ),
      );
      verify(
        () => firebaseHealthMeasurementService.loadMeasurementsByDateRange(
          startDate: startDate,
          endDate: endDate,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'get all measurements, '
    'should emit existing and matching measurements, should load new measurements from firebase and should also emit newly loaded measurements',
    () {
      final List<HealthMeasurement> existingMeasurements = [
        HealthMeasurement(
          userId: 'u2',
          date: DateTime(2023, 1, 2),
          restingHeartRate: 50,
          fastingWeight: 50.5,
        ),
        HealthMeasurement(
          userId: userId,
          date: DateTime(2023, 1, 3),
          restingHeartRate: 53,
          fastingWeight: 51.5,
        ),
        HealthMeasurement(
          userId: 'u2',
          date: DateTime(2023, 1, 8),
          restingHeartRate: 50,
          fastingWeight: 50.8,
        ),
      ];
      final List<HealthMeasurementDto> loadedMeasurementDtos = [
        HealthMeasurementDto(
          userId: userId,
          date: DateTime(2023, 1, 5),
          restingHeartRate: 49,
          fastingWeight: 52.4,
        ),
        HealthMeasurementDto(
          userId: userId,
          date: DateTime(2023, 1, 6),
          restingHeartRate: 49,
          fastingWeight: 52.8,
        ),
      ];
      final List<HealthMeasurement> loadedMeasurements = [
        HealthMeasurement(
          userId: userId,
          date: DateTime(2023, 1, 5),
          restingHeartRate: 49,
          fastingWeight: 52.4,
        ),
        HealthMeasurement(
          userId: userId,
          date: DateTime(2023, 1, 6),
          restingHeartRate: 49,
          fastingWeight: 52.8,
        ),
      ];
      firebaseHealthMeasurementService.mockLoadAllMeasurements(
        healthMeasurementDtos: loadedMeasurementDtos,
      );
      repository = createRepository(initialState: existingMeasurements);

      Stream<List<HealthMeasurement>?> measurements$ =
          repository.getAllMeasurements(userId: userId);
      measurements$.listen((_) {});

      expect(
        measurements$,
        emitsInOrder(
          [
            [
              existingMeasurements[1],
            ],
            [
              existingMeasurements[1],
              ...loadedMeasurements,
            ],
          ],
        ),
      );
      verify(
        () => firebaseHealthMeasurementService.loadAllMeasurements(
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'add measurement, '
    "should call firebase service's method to add measurement and should add this new measurement to repo state",
    () {
      final DateTime date = DateTime(2023, 2, 9);
      const int restingHeartRate = 55;
      const double fastingWeight = 55.5;
      final HealthMeasurement healthMeasurement = HealthMeasurement(
        userId: userId,
        date: date,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );
      final HealthMeasurementDto healthMeasurementDto = HealthMeasurementDto(
        userId: userId,
        date: date,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );
      firebaseHealthMeasurementService.mockAddMeasurement(
        addedMeasurementDto: healthMeasurementDto,
      );
      repository = createRepository();

      final Stream<List<HealthMeasurement>?> state$ = repository.dataStream$;
      repository.addMeasurement(measurement: healthMeasurement);

      expect(
        state$,
        emitsInOrder(
          [
            null,
            [healthMeasurement]
          ],
        ),
      );
      verify(
        () => firebaseHealthMeasurementService.addMeasurement(
          userId: userId,
          measurementDto: healthMeasurementDto,
        ),
      ).called(1);
    },
  );
}
