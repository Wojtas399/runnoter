import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/health_measurement_creator/bloc/health_measurement_creator_bloc.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_health_measurement_repository.dart';
import '../../../mock/presentation/service/mock_date_service.dart';
import '../../../util/health_measurement_creator.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();

  HealthMeasurementCreatorBloc createBloc({
    String? restingHeartRateStr,
    String? fastingWeightStr,
  }) =>
      HealthMeasurementCreatorBloc(
        dateService: dateService,
        authService: authService,
        healthMeasurementRepository: healthMeasurementRepository,
        restingHeartRateStr: restingHeartRateStr,
        fastingWeightStr: fastingWeightStr,
      );

  HealthMeasurementCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    String? restingHeartRateStr,
    String? fastingWeightStr,
  }) =>
      HealthMeasurementCreatorState(
        status: status,
        date: date,
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
    'should get today date and should emit it',
    build: () => createBloc(),
    setUp: () => dateService.mockGetToday(
      todayDate: DateTime(2023, 5, 10),
    ),
    act: (HealthMeasurementCreatorBloc bloc) => bloc.add(
      const HealthMeasurementCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 5, 10),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'given date is not null, '
    'should load health measurement from repository and should emit date, resting heart rate, fasting wright and bloc info that measurement has been loaded',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      healthMeasurementRepository.mockGetMeasurementByDate(
        measurement: createHealthMeasurement(
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
        date: DateTime(2023, 5, 10),
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
}
