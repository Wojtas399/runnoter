import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/morning_measurement.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/health/bloc/health_bloc.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_morning_measurement_repository.dart';
import '../../../mock/presentation/service/mock_date_service.dart';

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
    MorningMeasurement? todayMorningMeasurement,
    ChartRange chartRange = ChartRange.week,
    List<MorningMeasurement>? morningMeasurements,
  }) =>
      HealthState(
        status: status,
        todayMorningMeasurement: todayMorningMeasurement,
        chartRange: chartRange,
        morningMeasurements: morningMeasurements,
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
    "should call morning measurement repository's method to add new morning measurement with today date",
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
        status: const BlocStatusComplete(),
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
