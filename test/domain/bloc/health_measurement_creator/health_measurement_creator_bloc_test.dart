import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/health_measurement_creator/health_measurement_creator_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';

import '../../../creators/health_measurement_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();

  HealthMeasurementCreatorBloc createBloc({
    HealthMeasurement? measurement,
    int? restingHeartRate,
    double? fastingWeight,
  }) =>
      HealthMeasurementCreatorBloc(
        dateService: dateService,
        authService: authService,
        healthMeasurementRepository: healthMeasurementRepository,
        measurement: measurement,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );

  HealthMeasurementCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    HealthMeasurement? measurement,
    int? restingHeartRate,
    double? fastingWeight,
  }) =>
      HealthMeasurementCreatorState(
        status: status,
        measurement: measurement,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );

  tearDown(() {
    reset(dateService);
    reset(authService);
    reset(healthMeasurementRepository);
  });

  blocTest(
    'initialize, '
    'given date is null, '
    'should emit complete status',
    build: () => createBloc(),
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'given date is not null, '
    'should load health measurement from repository and should emit loaded measurement, resting heart rate and fasting weight',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      healthMeasurementRepository.mockGetMeasurementByDate(
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
      );
    },
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      HealthMeasurementCreatorEventInitialize(
        date: DateTime(2023, 5, 10),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
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
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'resting heart rate changed, '
    'should update resting heart rate in state',
    build: () => createBloc(),
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventRestingHeartRateChanged(
        restingHeartRate: 50,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        restingHeartRate: 50,
      ),
    ],
  );

  blocTest(
    'fasting weight changed, '
    'should update fasting weight in state',
    build: () => createBloc(),
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventFastingWeightChanged(
        fastingWeight: 61.5,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        fastingWeight: 61.5,
      ),
    ],
  );

  blocTest(
    'submit, '
    'params are invalid, '
    'should do nothing',
    build: () => createBloc(
      restingHeartRate: null,
      fastingWeight: 0,
    ),
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventSubmit(),
    ),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user bloc status',
    build: () => createBloc(
      restingHeartRate: 50,
      fastingWeight: 65.2,
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
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
    'measurement is null, '
    'should get today date, should call method from health measurement repository to add new measurement with today date and should emit info about saved measurement',
    build: () => createBloc(
      restingHeartRate: 50,
      fastingWeight: 65.2,
    ),
    setUp: () {
      dateService.mockGetToday(
        todayDate: DateTime(2023, 5, 12),
      );
      authService.mockGetLoggedUserId(userId: 'u1');
      healthMeasurementRepository.mockAddMeasurement();
    },
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
      createState(
        status: const BlocStatusComplete<HealthMeasurementCreatorBlocInfo>(
          info: HealthMeasurementCreatorBlocInfo.measurementSaved,
        ),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.addMeasurement(
          measurement: HealthMeasurement(
            userId: 'u1',
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
    'should call method from health measurement repository to update measurement and should emit info about saved measurement',
    build: () => createBloc(
      measurement: createHealthMeasurement(
        date: DateTime(2023, 5, 10),
        restingHeartRate: 50,
        fastingWeight: 61.5,
      ),
      restingHeartRate: 50,
      fastingWeight: 65.2,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      healthMeasurementRepository.mockUpdateMeasurement();
    },
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
      createState(
        status: const BlocStatusComplete<HealthMeasurementCreatorBlocInfo>(
          info: HealthMeasurementCreatorBlocInfo.measurementSaved,
        ),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.updateMeasurement(
          userId: 'u1',
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 65.2,
        ),
      ).called(1);
    },
  );
}
