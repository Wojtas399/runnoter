import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/presentation/screen/calendar/bloc/calendar_cubit.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_workout_repository.dart';
import '../../../util/workout_creator.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();

  CalendarCubit createCubit() => CalendarCubit(
        authService: authService,
        workoutRepository: workoutRepository,
      );

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
  });

  blocTest(
    'on month changed, '
    'should set new listener of workouts from new month',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetWorkoutsByDateRange(
        workouts: [
          createWorkout(id: 'w1', name: 'workout 1'),
          createWorkout(id: 'w2', name: 'workout 2'),
        ],
      );
    },
    act: (CalendarCubit cubit) => cubit.onMonthChanged(
      firstDisplayingDate: DateTime(2023, 1, 1),
      lastDisplayingDate: DateTime(2023, 1, 31),
    ),
    expect: () => [
      [
        createWorkout(id: 'w1', name: 'workout 1'),
        createWorkout(id: 'w2', name: 'workout 2'),
      ],
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutsByDateRange(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 1, 31),
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
