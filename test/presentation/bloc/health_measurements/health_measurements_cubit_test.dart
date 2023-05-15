import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/presentation/screen/health_measurements/health_measurements_cubit.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_health_measurement_repository.dart';
import '../../../util/health_measurement_creator.dart';

void main() {
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();

  HealthMeasurementsCubit createCubit() => HealthMeasurementsCubit(
        authService: authService,
        healthMeasurementRepository: healthMeasurementRepository,
      );

  tearDown(() {
    reset(authService);
    reset(healthMeasurementRepository);
  });

  blocTest(
    'initialize, '
    'should set listener of all measurements and should sort measurements in descending order by date',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      healthMeasurementRepository.mockGetAllMeasurements(
        measurements: [
          createHealthMeasurement(date: DateTime(2023, 2, 14)),
          createHealthMeasurement(date: DateTime(2023, 2, 8)),
          createHealthMeasurement(date: DateTime(2023, 2, 10)),
          createHealthMeasurement(date: DateTime(2023, 2, 11)),
        ],
      );
    },
    act: (HealthMeasurementsCubit cubit) => cubit.initialize(),
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
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
