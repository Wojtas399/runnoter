import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/repository/health_measurement_repository.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/domain/cubit/health_measurements_cubit.dart';

import '../../creators/health_measurement_creator.dart';
import '../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
  });

  tearDown(() {
    reset(authService);
    reset(healthMeasurementRepository);
  });

  blocTest(
    'initialize, '
    'should set listener of all measurements and should sort measurements in descending order by date',
    build: () => HealthMeasurementsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockGetAllMeasurements(
        measurements: [
          createHealthMeasurement(date: DateTime(2023, 2, 14)),
          createHealthMeasurement(date: DateTime(2023, 2, 8)),
          createHealthMeasurement(date: DateTime(2023, 2, 10)),
          createHealthMeasurement(date: DateTime(2023, 2, 11)),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      [
        createHealthMeasurement(date: DateTime(2023, 2, 14)),
        createHealthMeasurement(date: DateTime(2023, 2, 11)),
        createHealthMeasurement(date: DateTime(2023, 2, 10)),
        createHealthMeasurement(date: DateTime(2023, 2, 8)),
      ],
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.getAllMeasurements(
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'delete measurement, '
    'logged user does not exist, '
    'should do nothing',
    build: () => HealthMeasurementsCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.deleteMeasurement(DateTime(2023, 5, 14)),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'delete measurement, '
    'should call method from health measurement repository to delete measurement',
    build: () => HealthMeasurementsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockDeleteMeasurement();
    },
    act: (cubit) => cubit.deleteMeasurement(DateTime(2023, 5, 14)),
    expect: () => [],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.deleteMeasurement(
          userId: loggedUserId,
          date: DateTime(2023, 5, 14),
        ),
      ).called(1);
    },
  );
}
