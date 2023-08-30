import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/health_measurement_creator/health_measurement_creator_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/repository/health_measurement_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/health_measurement_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  const String loggedUserId = 'u1';

  HealthMeasurementCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    HealthMeasurement? measurement,
    DateTime? date,
    int? restingHeartRate,
    double? fastingWeight,
  }) =>
      HealthMeasurementCreatorState(
        dateService: dateService,
        status: status,
        measurement: measurement,
        date: date,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );

  setUpAll(() {
    GetIt.I.registerFactory<DateService>(() => dateService);
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
  });

  setUp(() {
    dateService.mockGetToday(
      todayDate: DateTime(2023, 5, 20),
    );
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
    build: () => HealthMeasurementCreatorBloc(),
    act: (bloc) => bloc.add(const HealthMeasurementCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete<HealthMeasurementCreatorBlocInfo>(),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'date is not null, '
    'should load health measurement from repository and should emit loaded measurement, date, resting heart rate and fasting weight',
    build: () => HealthMeasurementCreatorBloc(date: DateTime(2023, 5, 10)),
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
    act: (bloc) => bloc.add(const HealthMeasurementCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
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
    build: () => HealthMeasurementCreatorBloc(),
    act: (bloc) => bloc.add(HealthMeasurementCreatorEventDateChanged(
      date: DateTime(2023, 2, 10),
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 2, 10),
      )
    ],
  );

  blocTest(
    'resting heart rate changed, '
    'should update resting heart rate in state',
    build: () => HealthMeasurementCreatorBloc(),
    act: (bloc) => bloc.add(
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
    build: () => HealthMeasurementCreatorBloc(),
    act: (bloc) => bloc.add(
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
    build: () => HealthMeasurementCreatorBloc(
      restingHeartRate: null,
      fastingWeight: 0,
    ),
    act: (bloc) => bloc.add(const HealthMeasurementCreatorEventSubmit()),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user bloc status',
    build: () => HealthMeasurementCreatorBloc(
      date: DateTime(2023, 5, 10),
      restingHeartRate: 50,
      fastingWeight: 65.2,
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const HealthMeasurementCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
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
    'should emit info that measurement with selected date has already been added',
    build: () => HealthMeasurementCreatorBloc(
      date: DateTime(2023, 5, 10),
      restingHeartRate: 50,
      fastingWeight: 65.2,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockDoesMeasurementFromDateExist(
        expected: true,
      );
    },
    act: (bloc) => bloc.add(const HealthMeasurementCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
      createState(
        status: const BlocStatusError<HealthMeasurementCreatorBlocError>(
          error: HealthMeasurementCreatorBlocError
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
    'should call repo method to add new measurement and should emit info about added measurement',
    build: () => HealthMeasurementCreatorBloc(
      date: DateTime(2023, 5, 12),
      restingHeartRate: 50,
      fastingWeight: 65.2,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockDoesMeasurementFromDateExist(
        expected: false,
      );
      healthMeasurementRepository.mockAddMeasurement();
    },
    act: (bloc) => bloc.add(const HealthMeasurementCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        date: DateTime(2023, 5, 12),
        restingHeartRate: 50,
        fastingWeight: 65.2,
      ),
      createState(
        status: const BlocStatusComplete<HealthMeasurementCreatorBlocInfo>(
          info: HealthMeasurementCreatorBlocInfo.measurementAdded,
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
    'should call repo method to update measurement and should emit info about updated measurement',
    build: () => HealthMeasurementCreatorBloc(
      measurement: createHealthMeasurement(
        date: DateTime(2023, 5, 10),
        restingHeartRate: 50,
        fastingWeight: 61.5,
      ),
      date: DateTime(2023, 5, 10),
      restingHeartRate: 52,
      fastingWeight: 65.2,
    ),
    setUp: () {
      dateService.mockAreDatesTheSame(expected: true);
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockUpdateMeasurement();
    },
    act: (bloc) => bloc.add(const HealthMeasurementCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 5, 10),
        restingHeartRate: 52,
        fastingWeight: 65.2,
      ),
      createState(
        status: const BlocStatusComplete<HealthMeasurementCreatorBlocInfo>(
          info: HealthMeasurementCreatorBlocInfo.measurementUpdated,
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
    'should call repo method to add measurement with new date and to delete measurement with old date and should emit info about updated measurement',
    build: () => HealthMeasurementCreatorBloc(
      measurement: createHealthMeasurement(
        date: DateTime(2023, 5, 10),
        restingHeartRate: 50,
        fastingWeight: 61.5,
      ),
      date: DateTime(2023, 5, 8),
      restingHeartRate: 52,
      fastingWeight: 65.2,
    ),
    setUp: () {
      dateService.mockAreDatesTheSame(expected: false);
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockDoesMeasurementFromDateExist(
        expected: false,
      );
      healthMeasurementRepository.mockAddMeasurement();
      healthMeasurementRepository.mockDeleteMeasurement();
    },
    act: (bloc) => bloc.add(const HealthMeasurementCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 50,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 5, 8),
        restingHeartRate: 52,
        fastingWeight: 65.2,
      ),
      createState(
        status: const BlocStatusComplete<HealthMeasurementCreatorBlocInfo>(
          info: HealthMeasurementCreatorBlocInfo.measurementUpdated,
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
