import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/health_measurement_creator/health_measurement_creator_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_health_measurement_repository.dart';
import '../../../mock/presentation/service/mock_date_service.dart';
import '../../../util/health_measurement_creator.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();

  HealthMeasurementCreatorBloc createBloc({
    HealthMeasurement? measurement,
    String? restingHeartRateStr,
    String? fastingWeightStr,
  }) =>
      HealthMeasurementCreatorBloc(
        dateService: dateService,
        authService: authService,
        healthMeasurementRepository: healthMeasurementRepository,
        measurement: measurement,
        restingHeartRateStr: restingHeartRateStr,
        fastingWeightStr: fastingWeightStr,
      );

  HealthMeasurementCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    HealthMeasurement? measurement,
    String? restingHeartRateStr,
    String? fastingWeightStr,
  }) =>
      HealthMeasurementCreatorState(
        status: status,
        measurement: measurement,
        restingHeartRateStr: restingHeartRateStr,
        fastingWeightStr: fastingWeightStr,
      );

  tearDown(() {
    reset(dateService);
    reset(authService);
    reset(healthMeasurementRepository);
  });

  blocTest(
    'initialize, '
    'given date is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventInitialize(),
    ),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'given date is not null, '
    'should load health measurement from repository and should emit loaded measurement, resting heart rate, fasting weight and bloc info that measurement has been loaded',
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
        status: const BlocStatusComplete<HealthMeasurementCreatorBlocInfo>(
          info: HealthMeasurementCreatorBlocInfo.measurementLoaded,
        ),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        restingHeartRateStr: '50',
        fastingWeightStr: '61.5',
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
        restingHeartRateStr: '50',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        restingHeartRateStr: '50',
      ),
    ],
  );

  blocTest(
    'fasting weight changed, '
    'should update fasting weight in state',
    build: () => createBloc(),
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventFastingWeightChanged(
        fastingWeightStr: '61.5',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        fastingWeightStr: '61.5',
      ),
    ],
  );

  blocTest(
    'submit, '
    'resting heart rate is not int number, '
    'should do nothing',
    build: () => createBloc(
      restingHeartRateStr: '50sw',
      fastingWeightStr: '65.2',
    ),
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventSubmit(),
    ),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'fasting weight is not double number, '
    'should do nothing',
    build: () => createBloc(
      restingHeartRateStr: '50',
      fastingWeightStr: '65.2sad',
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
      restingHeartRateStr: '50',
      fastingWeightStr: '65.2',
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        restingHeartRateStr: '50',
        fastingWeightStr: '65.2',
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
      restingHeartRateStr: '50',
      fastingWeightStr: '65.2',
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
        restingHeartRateStr: '50',
        fastingWeightStr: '65.2',
      ),
      createState(
        status: const BlocStatusComplete<HealthMeasurementCreatorBlocInfo>(
          info: HealthMeasurementCreatorBlocInfo.measurementSaved,
        ),
        restingHeartRateStr: '50',
        fastingWeightStr: '65.2',
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
      restingHeartRateStr: '50',
      fastingWeightStr: '65.2',
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
        restingHeartRateStr: '50',
        fastingWeightStr: '65.2',
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
        restingHeartRateStr: '50',
        fastingWeightStr: '65.2',
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
