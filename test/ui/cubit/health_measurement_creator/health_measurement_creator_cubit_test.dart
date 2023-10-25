import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/data/model/health_measurement.dart';
import 'package:runnoter/data/repository/health_measurement/health_measurement_repository.dart';
import 'package:runnoter/data/service/auth/auth_service.dart';
import 'package:runnoter/ui/cubit/health_measurement_creator/health_measurement_creator_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

import '../../../creators/health_measurement_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/data/repository/mock_health_measurement_repository.dart';
import '../../../mock/data/service/mock_auth_service.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<DateService>(() => dateService);
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
  });

  setUp(() {
    dateService.mockGetToday(todayDate: DateTime(2023, 5, 20));
  });

  tearDown(() {
    reset(dateService);
    reset(authService);
    reset(healthMeasurementRepository);
  });

  blocTest(
    'initialize, '
    'date is null, '
    'should emit complete status',
    build: () => HealthMeasurementCreatorCubit(),
    act: (cubit) => cubit.initialize(null),
    expect: () => [
      HealthMeasurementCreatorState(status: const CubitStatusComplete()),
    ],
  );

  blocTest(
    'initialize, '
    'date is not null, '
    'should load health measurement from repository and '
    'should emit loaded measurement, date, resting heart rate and fasting weight',
    build: () => HealthMeasurementCreatorCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockGetMeasurementByDate(
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
      );
    },
    act: (cubit) => cubit.initialize(DateTime(2023, 5, 10)),
    expect: () => [
      HealthMeasurementCreatorState(
        status: const CubitStatusComplete(),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 50,
        fastingWeight: 61.5,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.getMeasurementByDate(
          date: DateTime(2023, 5, 10),
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'date changed, '
    'should update date in state',
    build: () => HealthMeasurementCreatorCubit(),
    act: (cubit) => cubit.dateChanged(DateTime(2023, 2, 10)),
    expect: () => [
      HealthMeasurementCreatorState(
        status: const CubitStatusComplete(),
        date: DateTime(2023, 2, 10),
      )
    ],
  );

  blocTest(
    'resting heart rate changed, '
    'should update resting heart rate in state',
    build: () => HealthMeasurementCreatorCubit(),
    act: (cubit) => cubit.restingHeartRateChanged(50),
    expect: () => [
      HealthMeasurementCreatorState(
        status: const CubitStatusComplete(),
        restingHeartRate: 50,
      ),
    ],
  );

  blocTest(
    'fasting weight changed, '
    'should update fasting weight in state',
    build: () => HealthMeasurementCreatorCubit(),
    act: (cubit) => cubit.fastingWeightChanged(61.5),
    expect: () => [
      HealthMeasurementCreatorState(
        status: const CubitStatusComplete(),
        fastingWeight: 61.5,
      ),
    ],
  );

  blocTest(
    'submit, '
    'params are invalid, '
    'should do nothing',
    build: () => HealthMeasurementCreatorCubit(
        initialState: HealthMeasurementCreatorState(
      status: const CubitStatusComplete(),
      restingHeartRate: null,
      fastingWeight: 0,
    )),
    act: (cubit) => cubit.submit(),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user bloc status',
    build: () => HealthMeasurementCreatorCubit(
      initialState: HealthMeasurementCreatorState(
        status: const CubitStatusComplete(),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      HealthMeasurementCreatorState(
        status: const CubitStatusNoLoggedUser(),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'submit, '
    'measurement with selected date has already been added, '
    'should emit error status with measurementWithSelectedDateAlreadyExist error',
    build: () => HealthMeasurementCreatorCubit(
      initialState: HealthMeasurementCreatorState(
        status: const CubitStatusComplete(),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockDoesMeasurementFromDateExist(
        expected: true,
      );
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      HealthMeasurementCreatorState(
        status: const CubitStatusLoading(),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
      HealthMeasurementCreatorState(
        status: const CubitStatusError<HealthMeasurementCreatorCubitError>(
          error: HealthMeasurementCreatorCubitError
              .measurementWithSelectedDateAlreadyExist,
        ),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.doesMeasurementFromDateExist(
          userId: loggedUserId,
          date: DateTime(2023, 5, 10),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'measurement is null, '
    'should call repo method to add new measurement and '
    'should emit complete status with measurementAdded info',
    build: () => HealthMeasurementCreatorCubit(
      initialState: HealthMeasurementCreatorState(
        status: const CubitStatusComplete(),
        date: DateTime(2023, 5, 12),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockDoesMeasurementFromDateExist(
        expected: false,
      );
      healthMeasurementRepository.mockAddMeasurement();
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      HealthMeasurementCreatorState(
        status: const CubitStatusLoading(),
        date: DateTime(2023, 5, 12),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
      HealthMeasurementCreatorState(
        status: const CubitStatusComplete<HealthMeasurementCreatorCubitInfo>(
          info: HealthMeasurementCreatorCubitInfo.measurementAdded,
        ),
        date: DateTime(2023, 5, 12),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.doesMeasurementFromDateExist(
          userId: loggedUserId,
          date: DateTime(2023, 5, 12),
        ),
      ).called(1);
      verify(
        () => healthMeasurementRepository.addMeasurement(
          measurement: HealthMeasurement(
            userId: loggedUserId,
            date: DateTime(2023, 5, 12),
            restingHeartRate: 50,
            fastingWeight: 65.2,
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'measurement is not null, '
    'date is same as original, '
    'should call repo method to update measurement and '
    'should emit complete status with measurementUpdated info',
    build: () => HealthMeasurementCreatorCubit(
      initialState: HealthMeasurementCreatorState(
        status: const CubitStatusComplete(),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 52,
        fastingWeight: 65.2,
      ),
    ),
    setUp: () {
      dateService.mockAreDaysTheSame(expected: true);
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockUpdateMeasurement();
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      HealthMeasurementCreatorState(
        status: const CubitStatusLoading(),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 52,
        fastingWeight: 65.2,
      ),
      HealthMeasurementCreatorState(
        status: const CubitStatusComplete<HealthMeasurementCreatorCubitInfo>(
          info: HealthMeasurementCreatorCubitInfo.measurementUpdated,
        ),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 52,
        fastingWeight: 65.2,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.updateMeasurement(
          userId: loggedUserId,
          date: DateTime(2023, 5, 10),
          restingHeartRate: 52,
          fastingWeight: 65.2,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'measurement is not null, '
    'date is different than original, '
    'should call repo method to add measurement with new date and '
    'should call repo method to delete measurement with old date and '
    'should emit complete status with measurementUpdated info',
    build: () => HealthMeasurementCreatorCubit(
      initialState: HealthMeasurementCreatorState(
        status: const CubitStatusComplete(),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 5, 8),
        restingHeartRate: 52,
        fastingWeight: 65.2,
      ),
    ),
    setUp: () {
      dateService.mockAreDaysTheSame(expected: false);
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockDoesMeasurementFromDateExist(
        expected: false,
      );
      healthMeasurementRepository.mockAddMeasurement();
      healthMeasurementRepository.mockDeleteMeasurement();
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      HealthMeasurementCreatorState(
        status: const CubitStatusLoading(),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 5, 8),
        restingHeartRate: 52,
        fastingWeight: 65.2,
      ),
      HealthMeasurementCreatorState(
        status: const CubitStatusComplete<HealthMeasurementCreatorCubitInfo>(
          info: HealthMeasurementCreatorCubitInfo.measurementUpdated,
        ),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 5, 8),
        restingHeartRate: 52,
        fastingWeight: 65.2,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.doesMeasurementFromDateExist(
          userId: loggedUserId,
          date: DateTime(2023, 5, 8),
        ),
      ).called(1);
      verify(
        () => healthMeasurementRepository.addMeasurement(
          measurement: HealthMeasurement(
            userId: loggedUserId,
            date: DateTime(2023, 5, 8),
            restingHeartRate: 52,
            fastingWeight: 65.2,
          ),
        ),
      ).called(1);
      verify(
        () => healthMeasurementRepository.deleteMeasurement(
          userId: loggedUserId,
          date: DateTime(2023, 5, 10),
        ),
      ).called(1);
    },
  );
}
