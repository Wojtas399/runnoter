import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/current_week/current_week_cubit.dart';

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
    "should set listener of logged user's workouts from week and should set days from current week in state",
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetToday(
        todayDate: DateTime(2023, 4, 5),
      );
      dateService.mockGetFirstDayOfTheWeek(
        date: DateTime(2023, 4, 3),
      );
      dateService.mockGetLastDayOfTheWeek(
        date: DateTime(2023, 4, 9),
      );
      dateService.mockGetDaysFromWeek(
        dates: [
          DateTime(2023, 4, 3),
          DateTime(2023, 4, 4),
          DateTime(2023, 4, 5),
          DateTime(2023, 4, 6),
          DateTime(2023, 4, 7),
          DateTime(2023, 4, 8),
          DateTime(2023, 4, 9),
        ],
      );
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      workoutRepository.mockGetWorkoutsByDateRange(
        workouts: [
          createWorkout(
            id: 'w1',
            date: DateTime(2023, 4, 5),
            name: 'first workout name',
          ),
          createWorkout(
            id: 'w2',
            date: DateTime(2023, 4, 7),
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
        Day(
          date: DateTime(2023, 4, 3),
          isToday: false,
          workout: null,
        ),
        Day(
          date: DateTime(2023, 4, 4),
          isToday: false,
          workout: null,
        ),
        Day(
          date: DateTime(2023, 4, 5),
          isToday: true,
          workout: createWorkout(
            id: 'w1',
            date: DateTime(2023, 4, 5),
            name: 'first workout name',
          ),
        ),
        Day(
          date: DateTime(2023, 4, 6),
          isToday: false,
          workout: null,
        ),
        Day(
          date: DateTime(2023, 4, 7),
          isToday: false,
          workout: createWorkout(
            id: 'w2',
            date: DateTime(2023, 4, 7),
            name: 'second workout name',
          ),
        ),
        Day(
          date: DateTime(2023, 4, 8),
          isToday: false,
          workout: null,
        ),
        Day(
          date: DateTime(2023, 4, 9),
          isToday: false,
          workout: null,
        ),
      ]
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutsByDateRange(
          userId: 'u1',
          startDate: DateTime(2023, 4, 3),
          endDate: DateTime(2023, 4, 9),
        ),
      ).called(1);
    },
  );
}
