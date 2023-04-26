import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/workout_stage.dart';
import 'package:runnoter/domain/model/workout_status.dart';
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
    String? workoutName,
    List<WorkoutStage>? stages,
    WorkoutStatus? workoutStatus,
  }) {
    return DayPreviewState(
      status: status,
      date: date,
      workoutName: workoutName,
      stages: stages,
      workoutStatus: workoutStatus,
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
      workoutRepository.mockGetWorkoutByUserIdAndDate();
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
    'pending workout, '
    'should update workout name, stages and status in state',
    build: () => createBloc(),
    act: (DayPreviewBloc bloc) => bloc.add(
      DayPreviewEventWorkoutUpdated(
        workout: createWorkout(
          id: 'w1',
          userId: 'u1',
          name: 'workout name',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 10,
              maxHeartRate: 150,
            ),
          ],
          status: const WorkoutStatusPending(),
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workoutName: 'workout name',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
        workoutStatus: const WorkoutStatusPending(),
      ),
    ],
  );

  blocTest(
    'workout updated, '
    'completed workout, '
    'should update workout name, stages, and status in state',
    build: () => createBloc(),
    act: (DayPreviewBloc bloc) => bloc.add(
      DayPreviewEventWorkoutUpdated(
        workout: createWorkout(
          id: 'w1',
          userId: 'u1',
          name: 'workout name',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 10,
              maxHeartRate: 150,
            ),
          ],
          status: WorkoutStatusCompleted(
            coveredDistanceInKm: 10,
            avgPace: const Pace(minutes: 6, seconds: 5),
            avgHeartRate: 144,
            moodRate: MoodRate.mr9,
            comment: 'comment',
          ),
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workoutName: 'workout name',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
        workoutStatus: WorkoutStatusCompleted(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 5),
          avgHeartRate: 144,
          moodRate: MoodRate.mr9,
          comment: 'comment',
        ),
      ),
    ],
  );

  blocTest(
    'workout updated, '
    'uncompleted workout, '
    'should update workout name, stages and status in state',
    build: () => createBloc(),
    act: (DayPreviewBloc bloc) => bloc.add(
      DayPreviewEventWorkoutUpdated(
        workout: createWorkout(
          id: 'w1',
          userId: 'u1',
          name: 'workout name',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 10,
              maxHeartRate: 150,
            ),
          ],
          status: WorkoutStatusUncompleted(
            coveredDistanceInKm: 10,
            avgPace: const Pace(minutes: 6, seconds: 5),
            avgHeartRate: 144,
            moodRate: MoodRate.mr9,
            comment: 'comment',
          ),
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workoutName: 'workout name',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
        workoutStatus: WorkoutStatusUncompleted(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 5),
          avgHeartRate: 144,
          moodRate: MoodRate.mr9,
          comment: 'comment',
        ),
      ),
    ],
  );
}
