import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/morning_measurement.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/health/bloc/health_bloc.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_morning_measurement_repository.dart';
import '../../../mock/presentation/service/mock_date_service.dart';
import '../../../util/morning_measurement_creator.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final morningMeasurementRepository = MockMorningMeasurementRepository();

  HealthBloc createBloc() => HealthBloc(
        dateService: dateService,
        authService: authService,
        morningMeasurementRepository: morningMeasurementRepository,
      );

  HealthState createState({
    BlocStatus status = const BlocStatusInitial(),
    MorningMeasurement? thisMorningMeasurement,
    ChartRange chartRange = ChartRange.week,
    List<MorningMeasurement>? morningMeasurements,
  }) =>
      HealthState(
        status: status,
        thisMorningMeasurement: thisMorningMeasurement,
        chartRange: chartRange,
        morningMeasurements: morningMeasurements,
      );

  tearDown(() {
    reset(dateService);
    reset(authService);
    reset(morningMeasurementRepository);
  });

  blocTest(
    'initialize, '
    "should set listener of logged user's this morning measurement",
    build: () => createBloc(),
    setUp: () {
      dateService.mockGetTodayDate(
        todayDate: DateTime(2023, 1, 10),
      );
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      morningMeasurementRepository.mockGetMeasurementByDate(
        measurement: createMorningMeasurement(
          date: DateTime(2023, 1, 10),
        ),
      );
    },
    act: (HealthBloc bloc) => bloc.add(
      const HealthEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        thisMorningMeasurement: createMorningMeasurement(
          date: DateTime(2023, 1, 10),
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => morningMeasurementRepository.getMeasurementByDate(
          date: DateTime(2023, 1, 10),
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'this morning measurement updated, '
    'should update today morning measurement in state',
    build: () => createBloc(),
    act: (HealthBloc bloc) => bloc.add(
      HealthEventThisMorningMeasurementUpdated(
        updatedThisMorningMeasurement: createMorningMeasurement(
          date: DateTime(2023, 1, 10),
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        thisMorningMeasurement: createMorningMeasurement(
          date: DateTime(2023, 1, 10),
        ),
      ),
    ],
  );

  blocTest(
    'add morning measurement, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (HealthBloc bloc) => bloc.add(
      const HealthEventAddMorningMeasurement(
        restingHeartRate: 50,
        weight: 80.2,
      ),
    ),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'add morning measurement, '
    'logged user exists, '
    "should call morning measurement repository's method to add new morning measurement with today date and should emit info that morning measurement has been added",
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      dateService.mockGetTodayDate(
        todayDate: DateTime(2023, 1, 10),
      );
      morningMeasurementRepository.mockAddMeasurement();
    },
    act: (HealthBloc bloc) => bloc.add(
      const HealthEventAddMorningMeasurement(
        restingHeartRate: 50,
        weight: 80.2,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<HealthBlocInfo>(
          info: HealthBlocInfo.morningMeasurementAdded,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => morningMeasurementRepository.addMeasurement(
          userId: 'u1',
          measurement: MorningMeasurement(
            date: DateTime(2023, 1, 10),
            restingHeartRate: 50,
            weight: 80.2,
          ),
        ),
      ).called(1);
    },
  );
}
