import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/data/repository_impl/health_measurement_repository_impl.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';

import '../../creators/health_measurement_creator.dart';
import '../../mock/common/mock_date_service.dart';
import '../../mock/firebase/mock_firebase_health_measurement_service.dart';

void main() {
  final dateService = MockDateService();
  final dbHealthMeasurementService = MockFirebaseHealthMeasurementService();
  late HealthMeasurementRepositoryImpl repository;
  const String userId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<DateService>(() => dateService);
    GetIt.I.registerFactory<FirebaseHealthMeasurementService>(
      () => dbHealthMeasurementService,
    );
  });

  setUp(() => repository = HealthMeasurementRepositoryImpl());

  tearDown(() {
    reset(dateService);
    reset(dbHealthMeasurementService);
  });

  test(
    'getMeasurementByDate, '
    'measurement exists in repository, '
    'should emit matching measurement',
    () {
      final DateTime date = DateTime(2023, 2, 9);
      final HealthMeasurement expectedHealthMeasurement =
          createHealthMeasurement(
        date: date,
        userId: userId,
      );
      repository = HealthMeasurementRepositoryImpl(
        initialData: [
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
        () => dateService.areDaysTheSame(DateTime(2023, 2, 10), date),
      ).thenReturn(false);
      when(
        () => dateService.areDaysTheSame(date, date),
      ).thenReturn(true);

      final Stream<HealthMeasurement?> measurement$ =
          repository.getMeasurementByDate(
        date: date,
        userId: userId,
      );

      expect(
        measurement$,
        emitsInOrder(
          [expectedHealthMeasurement],
        ),
      );
    },
  );

  test(
    'getMeasurementByDate, '
    'measurement does not exist in repository, '
    'should load measurement from db and should emit loaded measurement',
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
      dbHealthMeasurementService.mockLoadMeasurementByDate(
        healthMeasurementDto: healthMeasurementDto,
      );
      repository = HealthMeasurementRepositoryImpl(
        initialData: [
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
        () => dateService.areDaysTheSame(DateTime(2023, 2, 10), date),
      ).thenReturn(false);
      when(
        () => dateService.areDaysTheSame(date, date),
      ).thenReturn(true);

      final Stream<HealthMeasurement?> measurement$ =
          repository.getMeasurementByDate(
        date: date,
        userId: userId,
      );

      expect(
        measurement$,
        emitsInOrder(
          [expectedHealthMeasurement],
        ),
      );
    },
  );

  test(
    'getMeasurementsByDateRange, '
    'should emit existing and matching measurements, should load new measurements from db and should also emit newly loaded measurements',
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
      dbHealthMeasurementService.mockLoadMeasurementsByDateRange(
        healthMeasurementDtos: loadedMeasurementDtos,
      );
      repository =
          HealthMeasurementRepositoryImpl(initialData: existingMeasurements);

      Stream<List<HealthMeasurement>?> measurements$ =
          repository.getMeasurementsByDateRange(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      );

      expect(
        measurements$,
        emitsInOrder(
          [
            [
              existingMeasurements[0],
              ...loadedMeasurements,
            ],
          ],
        ),
      );
    },
  );

  test(
    'getAllMeasurements, '
    'should load new measurements from remote db and should emit measurements belonging to given user',
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
      dbHealthMeasurementService.mockLoadAllMeasurements(
        healthMeasurementDtos: loadedMeasurementDtos,
      );
      repository =
          HealthMeasurementRepositoryImpl(initialData: existingMeasurements);

      Stream<List<HealthMeasurement>?> measurements$ =
          repository.getAllMeasurements(userId: userId);

      expect(
        measurements$,
        emitsInOrder(
          [
            [
              existingMeasurements[1],
              ...loadedMeasurements,
            ],
          ],
        ),
      );
    },
  );

  test(
    'refreshMeasurementsByDateRange, '
    'should load measurements by date range from db and '
    'should add or update them in repo',
    () async {
      final DateTime startDate = DateTime(2023, 1, 10);
      final DateTime endDate = DateTime(2023, 1, 17);
      final List<HealthMeasurement> existingMeasurements = [
        HealthMeasurement(
          userId: 'u1',
          date: DateTime(2023, 1, 11),
          restingHeartRate: 48,
          fastingWeight: 75,
        ),
        HealthMeasurement(
          userId: 'u1',
          date: DateTime(2023, 1, 12),
          restingHeartRate: 50,
          fastingWeight: 78,
        ),
      ];
      final List<HealthMeasurementDto> loadedMeasurementDtos = [
        HealthMeasurementDto(
          userId: 'u1',
          date: DateTime(2023, 1, 11),
          restingHeartRate: 47,
          fastingWeight: 76,
        ),
        HealthMeasurementDto(
          userId: 'u1',
          date: DateTime(2023, 1, 13),
          restingHeartRate: 49,
          fastingWeight: 76.5,
        ),
      ];
      final List<HealthMeasurement> loadedMeasurements = [
        HealthMeasurement(
          userId: 'u1',
          date: DateTime(2023, 1, 11),
          restingHeartRate: 47,
          fastingWeight: 76,
        ),
        HealthMeasurement(
          userId: 'u1',
          date: DateTime(2023, 1, 13),
          restingHeartRate: 49,
          fastingWeight: 76.5,
        ),
      ];
      dbHealthMeasurementService.mockLoadMeasurementsByDateRange(
        healthMeasurementDtos: loadedMeasurementDtos,
      );
      repository = HealthMeasurementRepositoryImpl(
        initialData: existingMeasurements,
      );

      await repository.refreshMeasurementsByDateRange(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      );

      expect(
        repository.dataStream$,
        emits([
          loadedMeasurements.first,
          existingMeasurements[1],
          loadedMeasurements.last,
        ]),
      );
      verify(
        () => dbHealthMeasurementService.loadMeasurementsByDateRange(
          startDate: startDate,
          endDate: endDate,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'doesMeasurementFromDateExist, '
    'measurement exist in repo, '
    'should return true',
    () async {
      final DateTime date = DateTime(2023, 7, 2);
      repository = HealthMeasurementRepositoryImpl(
        initialData: [
          createHealthMeasurement(userId: userId, date: date),
        ],
      );
      dateService.mockAreDatesTheSame(expected: true);

      final bool doesMeasurementExist = await repository
          .doesMeasurementFromDateExist(userId: userId, date: date);

      expect(doesMeasurementExist, true);
    },
  );

  test(
    'doesMeasurementFromDateExist, '
    'measurement does not exist in repo, '
    'measurement loaded from remote db is not null, '
    'should add measurement to repo and should return true',
    () async {
      final DateTime date = DateTime(2023, 7, 2);
      final loadedMeasurementDto = HealthMeasurementDto(
        userId: userId,
        date: date,
        restingHeartRate: 50,
        fastingWeight: 60,
      );
      final loadedMeasurement = HealthMeasurement(
        userId: userId,
        date: date,
        restingHeartRate: 50,
        fastingWeight: 60,
      );
      repository = HealthMeasurementRepositoryImpl(
        initialData: [
          createHealthMeasurement(userId: 'u2', date: date),
        ],
      );
      dateService.mockAreDatesTheSame(expected: false);
      dbHealthMeasurementService.mockLoadMeasurementByDate(
        healthMeasurementDto: loadedMeasurementDto,
      );

      final bool doesMeasurementExist = await repository
          .doesMeasurementFromDateExist(userId: userId, date: date);

      expect(doesMeasurementExist, true);
      expect(
        repository.dataStream$,
        emitsInOrder(
          [
            [
              createHealthMeasurement(userId: 'u2', date: date),
              loadedMeasurement,
            ],
          ],
        ),
      );
    },
  );

  test(
    'doesMeasurementFromDateExist, '
    'measurement does not exist in repo, '
    'measurement loaded from remote db is null, '
    'should return false',
    () async {
      final DateTime date = DateTime(2023, 7, 2);
      repository = HealthMeasurementRepositoryImpl(
        initialData: [
          createHealthMeasurement(userId: 'u2', date: date),
        ],
      );
      dateService.mockAreDatesTheSame(expected: false);
      dbHealthMeasurementService.mockLoadMeasurementByDate();

      final bool doesMeasurementExist = await repository
          .doesMeasurementFromDateExist(userId: userId, date: date);

      expect(doesMeasurementExist, false);
    },
  );

  test(
    'addMeasurement, '
    'should add measurement to db and repo',
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
      dbHealthMeasurementService.mockAddMeasurement(
        addedMeasurementDto: healthMeasurementDto,
      );
      repository = HealthMeasurementRepositoryImpl();

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
        () => dbHealthMeasurementService.addMeasurement(
          userId: userId,
          measurementDto: healthMeasurementDto,
        ),
      ).called(1);
    },
  );

  test(
    'updateMeasurement, '
    'should update measurement in db and in repo',
    () {
      final DateTime date = DateTime(2023, 2, 9);
      const int newRestingHeartRate = 55;
      const double newFastingWeight = 64.2;
      final List<HealthMeasurement> existingMeasurements = [
        createHealthMeasurement(
          userId: 'u2',
          date: DateTime(2023, 2, 9),
        ),
        HealthMeasurement(
          userId: userId,
          date: date,
          restingHeartRate: 51,
          fastingWeight: 62.5,
        ),
      ];
      final HealthMeasurementDto updatedHealthMeasurementDto =
          HealthMeasurementDto(
        userId: userId,
        date: date,
        restingHeartRate: newRestingHeartRate,
        fastingWeight: newFastingWeight,
      );
      final HealthMeasurement updatedHealthMeasurement = HealthMeasurement(
        userId: userId,
        date: date,
        restingHeartRate: newRestingHeartRate,
        fastingWeight: newFastingWeight,
      );
      dbHealthMeasurementService.mockUpdateMeasurement(
        updatedMeasurementDto: updatedHealthMeasurementDto,
      );
      repository = HealthMeasurementRepositoryImpl(
        initialData: existingMeasurements,
      );

      final Stream<List<HealthMeasurement>?> state$ = repository.dataStream$;
      repository.updateMeasurement(
        userId: userId,
        date: date,
        restingHeartRate: newRestingHeartRate,
        fastingWeight: newFastingWeight,
      );

      expect(
        state$,
        emitsInOrder(
          [
            existingMeasurements,
            [
              createHealthMeasurement(
                userId: 'u2',
                date: DateTime(2023, 2, 9),
              ),
              updatedHealthMeasurement,
            ]
          ],
        ),
      );
      verify(
        () => dbHealthMeasurementService.updateMeasurement(
          userId: userId,
          date: date,
          restingHeartRate: newRestingHeartRate,
          fastingWeight: newFastingWeight,
        ),
      ).called(1);
    },
  );

  test(
    'deleteMeasurement, '
    'should delete measurement in db and in repo',
    () {
      final DateTime date = DateTime(2023, 2, 9);
      final List<HealthMeasurement> existingMeasurements = [
        createHealthMeasurement(
          userId: 'u2',
          date: DateTime(2023, 2, 9),
        ),
        createHealthMeasurement(
          userId: userId,
          date: date,
        ),
      ];
      dateService.mockAreDatesTheSame(expected: false);
      when(
        () => dateService.areDaysTheSame(date, date),
      ).thenReturn(true);
      dbHealthMeasurementService.mockDeleteMeasurement();
      repository = HealthMeasurementRepositoryImpl(
        initialData: existingMeasurements,
      );

      final Stream<List<HealthMeasurement>?> state$ = repository.dataStream$;
      repository.deleteMeasurement(
        userId: userId,
        date: date,
      );

      expect(
        state$,
        emitsInOrder(
          [
            existingMeasurements,
            [
              createHealthMeasurement(
                userId: 'u2',
                date: DateTime(2023, 2, 9),
              ),
            ]
          ],
        ),
      );
      verify(
        () => dbHealthMeasurementService.deleteMeasurement(
          userId: userId,
          date: date,
        ),
      ).called(1);
    },
  );

  test(
    'deleteAllUserMeasurements, '
    'should delete all user measurements in db and in repo',
    () {
      final List<HealthMeasurement> existingMeasurements = [
        createHealthMeasurement(
          userId: 'u2',
          date: DateTime(2023, 2, 9),
        ),
        createHealthMeasurement(
          userId: userId,
          date: DateTime(2023, 2, 10),
        ),
        createHealthMeasurement(
          userId: 'u2',
          date: DateTime(2023, 2, 11),
        ),
        createHealthMeasurement(
          userId: userId,
          date: DateTime(2023, 2, 12),
        ),
      ];
      dbHealthMeasurementService.mockDeleteAllUserMeasurements(
        idsOfDeletedMeasurements: ['2023-02-10', '2023-02,12'],
      );
      repository = HealthMeasurementRepositoryImpl(
        initialData: existingMeasurements,
      );

      final Stream<List<HealthMeasurement>?> state$ = repository.dataStream$;
      repository.deleteAllUserMeasurements(userId: userId);

      expect(
        state$,
        emitsInOrder(
          [
            existingMeasurements,
            [
              existingMeasurements.first,
              existingMeasurements[2],
            ]
          ],
        ),
      );
      verify(
        () => dbHealthMeasurementService.deleteAllUserMeasurements(
          userId: userId,
        ),
      ).called(1);
    },
  );
}
