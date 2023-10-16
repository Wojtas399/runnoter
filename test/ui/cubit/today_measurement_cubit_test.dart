import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/data/interface/repository/health_measurement_repository.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/data/model/health_measurement.dart';
import 'package:runnoter/ui/cubit/today_measurement_cubit.dart';

import '../../creators/health_measurement_creator.dart';
import '../../mock/common/mock_date_service.dart';
import '../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final dateService = MockDateService();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
    GetIt.I.registerFactory<DateService>(() => dateService);
  });

  tearDown(() {
    reset(authService);
    reset(healthMeasurementRepository);
    reset(dateService);
  });

  group(
    'initialize',
    () {
      final DateTime today = DateTime(2023, 8, 21);
      final HealthMeasurement measurement = createHealthMeasurement(
        date: today,
      );
      final StreamController<HealthMeasurement?> measurement$ =
          StreamController()..add(measurement);

      blocTest(
        "should set listener of logged user's today measurement",
        build: () => TodayMeasurementCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          dateService.mockGetToday(todayDate: today);
          healthMeasurementRepository.mockGetMeasurementByDate(
            measurementStream: measurement$.stream,
          );
        },
        act: (cubit) {
          cubit.initialize();
          measurement$.add(null);
        },
        expect: () => [measurement, null],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => healthMeasurementRepository.getMeasurementByDate(
              date: today,
              userId: loggedUserId,
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'delete today measurement, '
    'today measurement does not exist, '
    'should do nothing',
    build: () => TodayMeasurementCubit(),
    act: (cubit) => cubit.deleteTodayMeasurement(),
    verify: (_) => verifyNever(
      () => healthMeasurementRepository.deleteMeasurement(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ),
  );

  blocTest(
    'delete today measurement, '
    "should call health measurement repository's method to delete measurement",
    build: () => TodayMeasurementCubit(
      initialTodayMeasurement: createHealthMeasurement(
        userId: loggedUserId,
        date: DateTime(2023, 8, 21),
      ),
    ),
    setUp: () => healthMeasurementRepository.mockDeleteMeasurement(),
    act: (cubit) => cubit.deleteTodayMeasurement(),
    verify: (_) => verify(
      () => healthMeasurementRepository.deleteMeasurement(
        userId: loggedUserId,
        date: DateTime(2023, 8, 21),
      ),
    ).called(1),
  );
}
