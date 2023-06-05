import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/mileage/mileage_cubit.dart';
import 'package:runnoter/domain/entity/run_status.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_workout_repository.dart';
import '../../../util/chart_month_creator.dart';
import '../../../util/run_status_creator.dart';
import '../../../util/workout_creator.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();

  MileageCubit createCubit() => MileageCubit(
        authService: authService,
        workoutRepository: workoutRepository,
      );

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should finish event call',
    build: () => createCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (MileageCubit cubit) => cubit.initialize(),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should create chart years which contain months with calculated mileage of done or aborted workouts',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetAllWorkouts(
        allWorkouts: [
          createWorkout(
            date: DateTime(2022, 6, 16),
            status: createRunStatusAborted(coveredDistanceInKm: 8),
          ),
          createWorkout(
            date: DateTime(2022, 6, 18),
            status: createRunStatusDone(coveredDistanceInKm: 7),
          ),
          createWorkout(
            date: DateTime(2022, 7, 20),
            status: const RunStatusPending(),
          ),
          createWorkout(
            date: DateTime(2023, 3, 16),
            status: const RunStatusUndone(),
          ),
          createWorkout(
            date: DateTime(2023, 5, 18),
            status: createRunStatusDone(coveredDistanceInKm: 5),
          ),
          createWorkout(
            date: DateTime(2023, 5, 20),
            status: createRunStatusDone(coveredDistanceInKm: 6),
          ),
          createWorkout(
            date: DateTime(2023, 5, 16),
            status: createRunStatusAborted(coveredDistanceInKm: 8),
          ),
          createWorkout(
            date: DateTime(2023, 7, 18),
            status: createRunStatusDone(coveredDistanceInKm: 8),
          ),
          createWorkout(
            date: DateTime(2023, 7, 20),
            status: createRunStatusAborted(coveredDistanceInKm: 10),
          ),
        ],
      );
    },
    act: (MileageCubit cubit) => cubit.initialize(),
    expect: () => [
      [
        ChartYear(
          year: 2022,
          months: [
            createChartMonth(month: Month.january),
            createChartMonth(month: Month.february),
            createChartMonth(month: Month.march),
            createChartMonth(month: Month.april),
            createChartMonth(month: Month.may),
            createChartMonth(month: Month.june, mileage: 15.0),
            createChartMonth(month: Month.july),
            createChartMonth(month: Month.august),
            createChartMonth(month: Month.september),
            createChartMonth(month: Month.october),
            createChartMonth(month: Month.november),
            createChartMonth(month: Month.december),
          ],
        ),
        ChartYear(
          year: 2023,
          months: [
            createChartMonth(month: Month.january),
            createChartMonth(month: Month.february),
            createChartMonth(month: Month.march),
            createChartMonth(month: Month.april),
            createChartMonth(month: Month.may, mileage: 19.0),
            createChartMonth(month: Month.june),
            createChartMonth(month: Month.july, mileage: 18.0),
            createChartMonth(month: Month.august),
            createChartMonth(month: Month.september),
            createChartMonth(month: Month.october),
            createChartMonth(month: Month.november),
            createChartMonth(month: Month.december),
          ],
        ),
      ],
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getAllWorkouts(
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
