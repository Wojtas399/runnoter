import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/health_measurements/health_measurements_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_health_measurement_repository.dart';
import '../../../creators/health_measurement_creator.dart';

void main() {
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();

  HealthMeasurementsBloc createBloc() => HealthMeasurementsBloc(
        authService: authService,
        healthMeasurementRepository: healthMeasurementRepository,
      );

  HealthMeasurementsState createState({
    BlocStatus status = const BlocStatusInitial(),
    List<HealthMeasurement>? measurements,
  }) =>
      HealthMeasurementsState(
        status: status,
        measurements: measurements,
      );

  tearDown(() {
    reset(authService);
    reset(healthMeasurementRepository);
  });

  blocTest(
    'initialize, '
    'should set listener of all measurements and should sort measurements in descending order by date',
    build: () => createBloc(),
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
    act: (HealthMeasurementsBloc bloc) => bloc.add(
      const HealthMeasurementsEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        measurements: [
          createHealthMeasurement(date: DateTime(2023, 2, 14)),
          createHealthMeasurement(date: DateTime(2023, 2, 11)),
          createHealthMeasurement(date: DateTime(2023, 2, 10)),
          createHealthMeasurement(date: DateTime(2023, 2, 8)),
        ],
      ),
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

  blocTest(
    'measurements updated, '
    'should sort measurements in descending order by date and should emit sorted measurements',
    build: () => createBloc(),
    act: (HealthMeasurementsBloc bloc) => bloc.add(
      HealthMeasurementsEventMeasurementsUpdated(
        measurements: [
          createHealthMeasurement(date: DateTime(2023, 2, 14)),
          createHealthMeasurement(date: DateTime(2023, 2, 8)),
          createHealthMeasurement(date: DateTime(2023, 2, 10)),
          createHealthMeasurement(date: DateTime(2023, 2, 11)),
        ],
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        measurements: [
          createHealthMeasurement(date: DateTime(2023, 2, 14)),
          createHealthMeasurement(date: DateTime(2023, 2, 11)),
          createHealthMeasurement(date: DateTime(2023, 2, 10)),
          createHealthMeasurement(date: DateTime(2023, 2, 8)),
        ],
      ),
    ],
  );

  blocTest(
    'delete measurement, '
    'logged user does not exist, '
    'should emit no logged user bloc status',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (HealthMeasurementsBloc bloc) => bloc.add(
      HealthMeasurementsEventDeleteMeasurement(
        date: DateTime(2023, 5, 14),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'delete measurement, '
    'should call method from health measurement repository to delete measurement and should emit bloc info about deleted measurement',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      healthMeasurementRepository.mockDeleteMeasurement();
    },
    act: (HealthMeasurementsBloc bloc) => bloc.add(
      HealthMeasurementsEventDeleteMeasurement(
        date: DateTime(2023, 5, 14),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<HealthMeasurementsBlocInfo>(
          info: HealthMeasurementsBlocInfo.measurementDeleted,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.deleteMeasurement(
          userId: 'u1',
          date: DateTime(2023, 5, 14),
        ),
      ).called(1);
    },
  );
}
