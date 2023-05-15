import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/workout_stage.dart';
import 'package:runnoter/domain/model/workout_status.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/day_preview/bloc/day_preview_bloc.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_workout_repository.dart';
import '../../../mock/presentation/service/mock_date_service.dart';
import '../../../util/workout_creator.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  final dateService = MockDateService();
  final DateTime date = DateTime(2023, 1, 1);

  DayPreviewBloc createBloc({
    String? workoutId,
  }) {
    return DayPreviewBloc(
      authService: authService,
      workoutRepository: workoutRepository,
      dateService: dateService,
      workoutId: workoutId,
    );
  }

  DayPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    bool? isPastDate,
    String? workoutId,
    String? workoutName,
    List<WorkoutStage>? stages,
    WorkoutStatus? workoutStatus,
  }) {
    return DayPreviewState(
      status: status,
      date: date,
      isPastDay: isPastDate,
      workoutId: workoutId,
      workoutName: workoutName,
      stages: stages,
      workoutStatus: workoutStatus,
    );
  }

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
    reset(dateService);
  });

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
    'should update date and isPastDay param in state and should set listener on workout matching to date and user id',
    build: () => createBloc(),
    setUp: () {
      dateService.mockGetToday(
        todayDate: DateTime(2023, 1, 10),
      );
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetWorkoutByDate(
        workout: createWorkout(
          id: 'w1',
          date: date,
          stages: [],
          status: const WorkoutStatusPending(),
          name: 'workout name',
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
        isPastDate: true,
      ),
      createState(
        status: const BlocStatusComplete(),
        date: date,
        isPastDate: true,
        workoutId: 'w1',
        stages: [],
        workoutStatus: const WorkoutStatusPending(),
        workoutName: 'workout name',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutByDate(
          userId: 'u1',
          date: date,
        ),
      ).called(1);
    },
  );

  blocTest(
    'workout updated, '
    'new workout is null, '
    'should set workout id as null in state',
    build: () => createBloc(
      workoutId: 'w1',
    ),
    act: (DayPreviewBloc bloc) => bloc.add(
      const DayPreviewEventWorkoutUpdated(workout: null),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workoutId: null,
      ),
    ],
  );

  blocTest(
    'workout updated, '
    'new workout is not null, '
    'should update workout id, name, stages and status in state',
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
        workoutId: 'w1',
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
    'edit workout, '
    'should emit DayPreviewInfo.editWorkout',
    build: () => createBloc(),
    act: (DayPreviewBloc bloc) => bloc.add(
      const DayPreviewEventEditWorkout(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<DayPreviewInfo>(
          info: DayPreviewInfo.editWorkout,
        ),
      ),
    ],
  );

  blocTest(
    'delete workout, '
    'workout id is null, '
    'should finish event call',
    build: () => createBloc(),
    act: (DayPreviewBloc bloc) => bloc.add(
      const DayPreviewEventDeleteWorkout(),
    ),
    expect: () => [],
  );

  blocTest(
    'delete workout, '
    'logged user does not exist, '
    'should finish event call',
    build: () => createBloc(
      workoutId: 'w1',
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (DayPreviewBloc bloc) => bloc.add(
      const DayPreviewEventDeleteWorkout(),
    ),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'delete workout, '
    'should call method from workout repository to delete workout and should emit info that workout has been deleted',
    build: () => createBloc(
      workoutId: 'w1',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockDeleteWorkout();
    },
    act: (DayPreviewBloc bloc) => bloc.add(
      const DayPreviewEventDeleteWorkout(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        workoutId: 'w1',
      ),
      createState(
        status: const BlocStatusComplete<DayPreviewInfo>(
          info: DayPreviewInfo.workoutDeleted,
        ),
        workoutId: 'w1',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.deleteWorkout(
          userId: 'u1',
          workoutId: 'w1',
        ),
      ).called(1);
    },
  );
}
