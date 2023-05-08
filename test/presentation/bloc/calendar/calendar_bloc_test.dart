import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/workout.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/calendar/bloc/calendar_bloc.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_workout_repository.dart';
import '../../../mock/presentation/service/mock_date_service.dart';
import '../../../util/workout_creator.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();

  CalendarBloc createBloc() => CalendarBloc(
        dateService: dateService,
        authService: authService,
        workoutRepository: workoutRepository,
      );

  CalendarState createState({
    BlocStatus status = const BlocStatusInitial(),
    List<Workout>? workouts,
  }) =>
      CalendarState(
        status: status,
        workouts: workouts,
      );

  blocTest(
    'workouts updated, '
    'should update workouts in state',
    build: () => createBloc(),
    act: (CalendarBloc bloc) => bloc.add(
      CalendarEventWorkoutsUpdated(
        workouts: [
          createWorkout(id: 'w1', name: 'workout 1'),
          createWorkout(id: 'w2', name: 'workout 2'),
        ],
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workouts: [
          createWorkout(id: 'w1', name: 'workout 1'),
          createWorkout(id: 'w2', name: 'workout 2'),
        ],
      ),
    ],
  );

  blocTest(
    'month changed, '
    'should set new listener of workouts from new month',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetWorkoutsByDateRange(
        workouts: [],
      );
    },
    act: (CalendarBloc bloc) => bloc.add(
      CalendarEventMonthChanged(
        firstDisplayingDate: DateTime(2023, 1, 1),
        lastDisplayingDate: DateTime(2023, 1, 31),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workouts: [],
      ),
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
