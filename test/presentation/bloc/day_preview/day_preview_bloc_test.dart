import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/workout.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/day_preview/bloc/day_preview_bloc.dart';
import 'package:runnoter/presentation/screen/day_preview/bloc/day_preview_event.dart';
import 'package:runnoter/presentation/screen/day_preview/bloc/day_preview_state.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_workout_repository.dart';
import '../../../util/workout_creator.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  final DateTime date = DateTime(2023, 1, 1);

  DayPreviewBloc createBloc() {
    return DayPreviewBloc(
      authService: authService,
      workoutRepository: workoutRepository,
    );
  }

  DayPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    Workout? workout,
  }) {
    return DayPreviewState(
      status: status,
      date: date,
      workout: workout,
    );
  }

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should finish event call',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (DayPreviewBloc bloc) => bloc.add(
      DayPreviewEventInitialize(date: date),
    ),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should update date in state and should set listener on workout matching to date and user id',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetWorkoutByUserIdAndDate(
        workout: createWorkout(
          id: 'w1',
          userId: 'u1',
          name: 'workout name',
          date: date,
        ),
      );
    },
    act: (DayPreviewBloc bloc) => bloc.add(
      DayPreviewEventInitialize(
        date: date,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: date,
      ),
      createState(
        status: const BlocStatusComplete(),
        date: date,
        workout: createWorkout(
          id: 'w1',
          userId: 'u1',
          name: 'workout name',
          date: date,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutByUserIdAndDate(
          userId: 'u1',
          date: date,
        ),
      ).called(1);
    },
  );

  blocTest(
    'workout updated, '
    'should update workout in state',
    build: () => createBloc(),
    act: (DayPreviewBloc bloc) => bloc.add(
      DayPreviewEventWorkoutUpdated(
        workout: createWorkout(
          id: 'w1',
          userId: 'u1',
          name: 'workout name',
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workout: createWorkout(
          id: 'w1',
          userId: 'u1',
          name: 'workout name',
        ),
      ),
    ],
  );
}
