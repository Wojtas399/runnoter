import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/presentation/screen/current_week/current_week_cubit.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_workout_repository.dart';
import '../../../mock/presentation/service/mock_date_service.dart';
import '../../../util/workout_creator.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();

  CurrentWeekCubit createCubit() {
    return CurrentWeekCubit(
      dateService: dateService,
      authService: authService,
      workoutRepository: workoutRepository,
    );
  }

  blocTest(
    'initialize, '
    "should set listener of logged user's workouts from week",
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetNow(
        now: DateTime(2023, 1, 1),
      );
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      workoutRepository.mockGetWorkoutsFromWeek(
        workouts: [
          createWorkout(
            id: 'w1',
            date: DateTime(2023, 1, 2),
            name: 'first workout name',
          ),
          createWorkout(
            id: 'w2',
            date: DateTime(2023, 1, 3),
            name: 'second workout name',
          ),
        ],
      );
    },
    act: (CurrentWeekCubit cubit) {
      cubit.initialize();
    },
    expect: () => [
      [
        createWorkout(
          id: 'w1',
          date: DateTime(2023, 1, 2),
          name: 'first workout name',
        ),
        createWorkout(
          id: 'w2',
          date: DateTime(2023, 1, 3),
          name: 'second workout name',
        ),
      ]
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutsFromWeek(
          userId: 'u1',
          dateFromWeek: DateTime(2023, 1, 1),
        ),
      ).called(1);
    },
  );
}
