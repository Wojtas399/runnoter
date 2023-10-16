import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/additional_model/activity_status.dart';
import 'package:runnoter/data/interface/repository/race_repository.dart';
import 'package:runnoter/data/interface/repository/workout_repository.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/ui/cubit/activity_status_creator/activity_status_creator_cubit.dart';

import '../../../creators/race_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';

void main() {
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  const String userId = 'u1';
  const String activityId = 'a1';

  ActivityStatusCreatorCubit createBloc({
    ActivityType activityType = ActivityType.workout,
    ActivityStatusType? activityStatusType,
    double? coveredDistanceInKm,
    Duration? duration,
    MoodRate? moodRate,
    Pace? avgPace,
    int? avgHeartRate,
    String? comment,
  }) =>
      ActivityStatusCreatorCubit(
        userId: userId,
        activityType: activityType,
        activityId: activityId,
        initialState: ActivityStatusCreatorState(
          status: const CubitStatusInitial(),
          activityStatusType: activityStatusType,
          coveredDistanceInKm: coveredDistanceInKm,
          duration: duration,
          moodRate: moodRate,
          avgPace: avgPace,
          avgHeartRate: avgHeartRate,
          comment: comment,
        ),
      );

  setUpAll(() {
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
    registerFallbackValue(const ActivityStatusPending());
  });

  tearDown(() {
    reset(workoutRepository);
    reset(raceRepository);
  });

  blocTest(
    'initialize, '
    'workout, '
    'activity status contains params, '
    'should load workout from repository and '
    'should update all params relevant to activity status',
    build: () => createBloc(),
    setUp: () => workoutRepository.mockGetWorkoutById(
      workout: createWorkout(
        status: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 2),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
      ),
    ),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        originalActivityStatus: ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 2),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 2),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.getWorkoutById(
        workoutId: activityId,
        userId: userId,
      ),
    ).called(1),
  );

  blocTest(
    'initialize, '
    'workout, '
    'activity status pending, '
    'should load workout from repository and '
    'should set activity status type as done',
    build: () => createBloc(),
    setUp: () => workoutRepository.mockGetWorkoutById(
      workout: createWorkout(status: const ActivityStatusPending()),
    ),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        originalActivityStatus: ActivityStatusPending(),
        activityStatusType: ActivityStatusType.done,
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.getWorkoutById(
        workoutId: activityId,
        userId: userId,
      ),
    ).called(1),
  );

  blocTest(
    'initialize, '
    'workout, '
    'activity status undone, '
    'should load workout from repository and '
    'should set activity status type as undone',
    build: () => createBloc(),
    setUp: () => workoutRepository.mockGetWorkoutById(
      workout: createWorkout(status: const ActivityStatusUndone()),
    ),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        originalActivityStatus: ActivityStatusUndone(),
        activityStatusType: ActivityStatusType.undone,
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.getWorkoutById(
        workoutId: activityId,
        userId: userId,
      ),
    ).called(1),
  );

  blocTest(
    'initialize, '
    'race, '
    'activity status contains params, '
    'should load race from repository and '
    'should update all params relevant to activity status',
    build: () => createBloc(activityType: ActivityType.race),
    setUp: () => raceRepository.mockGetRaceById(
      race: createRace(
        status: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 2),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
      ),
    ),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        originalActivityStatus: ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 2),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 2),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.getRaceById(raceId: activityId, userId: userId),
    ).called(1),
  );

  blocTest(
    'initialize, '
    'race, '
    'activity status pending, '
    'should load race from repository and '
    'should set activity status type as done',
    build: () => createBloc(activityType: ActivityType.race),
    setUp: () => raceRepository.mockGetRaceById(
      race: createRace(status: const ActivityStatusPending()),
    ),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        originalActivityStatus: ActivityStatusPending(),
        activityStatusType: ActivityStatusType.done,
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.getRaceById(raceId: activityId, userId: userId),
    ).called(1),
  );

  blocTest(
    'initialize, '
    'race, '
    'activity status undone, '
    'should load race from repository and '
    'should set activity status type as undone',
    build: () => createBloc(activityType: ActivityType.race),
    setUp: () => raceRepository.mockGetRaceById(
      race: createRace(status: const ActivityStatusUndone()),
    ),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        originalActivityStatus: ActivityStatusUndone(),
        activityStatusType: ActivityStatusType.undone,
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.getRaceById(raceId: activityId, userId: userId),
    ).called(1),
  );

  blocTest(
    'activity status type changed, '
    'should update activity status type in state',
    build: () => createBloc(),
    act: (cubit) => cubit.activityStatusTypeChanged(ActivityStatusType.done),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        activityStatusType: ActivityStatusType.done,
      ),
    ],
  );

  blocTest(
    'covered distance in km changed, '
    'should update covered distance in km in state',
    build: () => createBloc(),
    act: (cubit) => cubit.coveredDistanceInKmChanged(10),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        coveredDistanceInKm: 10,
      ),
    ],
  );

  blocTest(
    'duration changed, '
    'should update duration in state',
    build: () => createBloc(),
    act: (cubit) => cubit.durationChanged(const Duration(seconds: 3)),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        duration: Duration(seconds: 3),
      ),
    ],
  );

  blocTest(
    'mood rate changed, '
    'should update mood rate in state',
    build: () => createBloc(),
    act: (cubit) => cubit.moodRateChanged(MoodRate.mr8),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        moodRate: MoodRate.mr8,
      ),
    ],
  );

  blocTest(
    'avg pace changed, '
    'should update average pace in state',
    build: () => createBloc(),
    act: (cubit) => cubit.avgPaceChanged(const Pace(minutes: 6, seconds: 10)),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        avgPace: Pace(minutes: 6, seconds: 10),
      ),
    ],
  );

  blocTest(
    'avg heart rate changed, '
    'should update average heart rate in state',
    build: () => createBloc(),
    act: (cubit) => cubit.avgHeartRateChanged(150),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        avgHeartRate: 150,
      ),
    ],
  );

  blocTest(
    'comment changed, ',
    build: () => createBloc(),
    act: (cubit) => cubit.commentChanged('comment'),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusComplete(),
        comment: 'comment',
      ),
    ],
  );

  blocTest(
    'submit, '
    'workout, '
    'activity status pending, '
    'should call workout repository method to update workout with pending status',
    build: () => createBloc(activityStatusType: ActivityStatusType.pending),
    setUp: () => workoutRepository.mockUpdateWorkout(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusLoading(),
        activityStatusType: ActivityStatusType.pending,
      ),
      const ActivityStatusCreatorState(
        status: CubitStatusComplete<ActivityStatusCreatorCubitInfo>(
          info: ActivityStatusCreatorCubitInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.pending,
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.updateWorkout(
        workoutId: activityId,
        userId: userId,
        status: const ActivityStatusPending(),
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'race, '
    'activity status pending, '
    'should call race repository method to update race with pending status',
    build: () => createBloc(
      activityType: ActivityType.race,
      activityStatusType: ActivityStatusType.pending,
    ),
    setUp: () => raceRepository.mockUpdateRace(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusLoading(),
        activityStatusType: ActivityStatusType.pending,
      ),
      const ActivityStatusCreatorState(
        status: CubitStatusComplete<ActivityStatusCreatorCubitInfo>(
          info: ActivityStatusCreatorCubitInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.pending,
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.updateRace(
        raceId: activityId,
        userId: userId,
        status: const ActivityStatusPending(),
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'workout, '
    'activity status done, '
    'should call workout repository method to update workout with done status',
    build: () => createBloc(
      activityStatusType: ActivityStatusType.done,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      avgPace: const Pace(minutes: 5, seconds: 50),
      avgHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () => workoutRepository.mockUpdateWorkout(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusLoading(),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      const ActivityStatusCreatorState(
        status: CubitStatusComplete<ActivityStatusCreatorCubitInfo>(
          info: ActivityStatusCreatorCubitInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.updateWorkout(
        workoutId: activityId,
        userId: userId,
        status: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 3),
          moodRate: MoodRate.mr8,
          avgPace: Pace(minutes: 5, seconds: 50),
          avgHeartRate: 150,
          comment: 'comment',
        ),
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'race, '
    'activity status done, '
    'should call race repository method to update race with done status',
    build: () => createBloc(
      activityType: ActivityType.race,
      activityStatusType: ActivityStatusType.done,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      avgPace: const Pace(minutes: 5, seconds: 50),
      avgHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () => raceRepository.mockUpdateRace(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusLoading(),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      const ActivityStatusCreatorState(
        status: CubitStatusComplete<ActivityStatusCreatorCubitInfo>(
          info: ActivityStatusCreatorCubitInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.updateRace(
        raceId: activityId,
        userId: userId,
        status: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 3),
          moodRate: MoodRate.mr8,
          avgPace: Pace(minutes: 5, seconds: 50),
          avgHeartRate: 150,
          comment: 'comment',
        ),
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'workout, '
    'activity status aborted, '
    'should call workout repository method to update workout with aborted status',
    build: () => createBloc(
      activityStatusType: ActivityStatusType.aborted,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      avgPace: const Pace(minutes: 5, seconds: 50),
      avgHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () => workoutRepository.mockUpdateWorkout(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusLoading(),
        activityStatusType: ActivityStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      const ActivityStatusCreatorState(
        status: CubitStatusComplete<ActivityStatusCreatorCubitInfo>(
          info: ActivityStatusCreatorCubitInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.updateWorkout(
        workoutId: activityId,
        userId: userId,
        status: const ActivityStatusAborted(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 3),
          moodRate: MoodRate.mr8,
          avgPace: Pace(minutes: 5, seconds: 50),
          avgHeartRate: 150,
          comment: 'comment',
        ),
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'race, '
    'activity status aborted, '
    'should call race repository method to update race with aborted status',
    build: () => createBloc(
      activityType: ActivityType.race,
      activityStatusType: ActivityStatusType.aborted,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      avgPace: const Pace(minutes: 5, seconds: 50),
      avgHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () => raceRepository.mockUpdateRace(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusLoading(),
        activityStatusType: ActivityStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      const ActivityStatusCreatorState(
        status: CubitStatusComplete<ActivityStatusCreatorCubitInfo>(
          info: ActivityStatusCreatorCubitInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.updateRace(
        raceId: activityId,
        userId: userId,
        status: const ActivityStatusAborted(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 3),
          moodRate: MoodRate.mr8,
          avgPace: Pace(minutes: 5, seconds: 50),
          avgHeartRate: 150,
          comment: 'comment',
        ),
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'workout, '
    'activity status undone, '
    'should call workout repository method to update workout with undone status',
    build: () => createBloc(activityStatusType: ActivityStatusType.undone),
    setUp: () => workoutRepository.mockUpdateWorkout(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusLoading(),
        activityStatusType: ActivityStatusType.undone,
      ),
      const ActivityStatusCreatorState(
        status: CubitStatusComplete<ActivityStatusCreatorCubitInfo>(
          info: ActivityStatusCreatorCubitInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.undone,
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.updateWorkout(
        workoutId: activityId,
        userId: userId,
        status: const ActivityStatusUndone(),
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'race, '
    'activity status undone, '
    'should call race repository method to update race with undone status',
    build: () => createBloc(
      activityType: ActivityType.race,
      activityStatusType: ActivityStatusType.undone,
    ),
    setUp: () => raceRepository.mockUpdateRace(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ActivityStatusCreatorState(
        status: CubitStatusLoading(),
        activityStatusType: ActivityStatusType.undone,
      ),
      const ActivityStatusCreatorState(
        status: CubitStatusComplete<ActivityStatusCreatorCubitInfo>(
          info: ActivityStatusCreatorCubitInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.undone,
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.updateRace(
        raceId: activityId,
        userId: userId,
        status: const ActivityStatusUndone(),
      ),
    ).called(1),
  );
}
