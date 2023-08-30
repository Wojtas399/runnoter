import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/activity_status_creator/activity_status_creator_bloc.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';

import '../../../creators/race_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';

void main() {
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  const String userId = 'u1';
  const String activityId = 'a1';

  ActivityStatusCreatorBloc createBloc({
    ActivityType activityType = ActivityType.workout,
    ActivityStatusType? activityStatusType,
    double? coveredDistanceInKm,
    Duration? duration,
    MoodRate? moodRate,
    Pace? avgPace,
    int? avgHeartRate,
    String? comment,
  }) =>
      ActivityStatusCreatorBloc(
        userId: userId,
        activityType: activityType,
        activityId: activityId,
        state: ActivityStatusCreatorState(
          status: const BlocStatusInitial(),
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
    'should load workout from repository and should update all params relevant to activity status',
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
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
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
    'should load workout from repository and should set activity status type as done',
    build: () => createBloc(),
    setUp: () => workoutRepository.mockGetWorkoutById(
      workout: createWorkout(status: const ActivityStatusPending()),
    ),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
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
    'should load workout from repository and should set activity status type as undone',
    build: () => createBloc(),
    setUp: () => workoutRepository.mockGetWorkoutById(
      workout: createWorkout(status: const ActivityStatusUndone()),
    ),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
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
    'should load race from repository and should update all params relevant to activity status',
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
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
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
    'should load race from repository and should set activity status type as done',
    build: () => createBloc(activityType: ActivityType.race),
    setUp: () => raceRepository.mockGetRaceById(
      race: createRace(status: const ActivityStatusPending()),
    ),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
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
    'should load race from repository and should set activity status type as undone',
    build: () => createBloc(activityType: ActivityType.race),
    setUp: () => raceRepository.mockGetRaceById(
      race: createRace(status: const ActivityStatusUndone()),
    ),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
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
    act: (bloc) => bloc.add(
      const ActivityStatusCreatorEventActivityStatusTypeChanged(
        activityStatusType: ActivityStatusType.done,
      ),
    ),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
        activityStatusType: ActivityStatusType.done,
      ),
    ],
  );

  blocTest(
    'covered distance in km changed, '
    'should update covered distance in km in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(
      const ActivityStatusCreatorEventCoveredDistanceInKmChanged(
        coveredDistanceInKm: 10,
      ),
    ),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
        coveredDistanceInKm: 10,
      ),
    ],
  );

  blocTest(
    'duration changed, '
    'should update duration in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventDurationChanged(
      duration: Duration(seconds: 3),
    )),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
        duration: Duration(seconds: 3),
      ),
    ],
  );

  blocTest(
    'mood rate changed, '
    'should update mood rate in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventMoodRateChanged(
      moodRate: MoodRate.mr8,
    )),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
        moodRate: MoodRate.mr8,
      ),
    ],
  );

  blocTest(
    'avg pace changed, '
    'should update average pace in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventAvgPaceChanged(
      avgPace: Pace(minutes: 6, seconds: 10),
    )),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
        avgPace: Pace(minutes: 6, seconds: 10),
      ),
    ],
  );

  blocTest(
    'avg heart rate changed, '
    'should update average heart rate in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventAvgHeartRateChanged(
      averageHeartRate: 150,
    )),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
        avgHeartRate: 150,
      ),
    ],
  );

  blocTest(
    'comment changed, ',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventCommentChanged(
      comment: 'comment',
    )),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusComplete(),
        comment: 'comment',
      ),
    ],
  );

  blocTest(
    'submit, '
    'workout, '
    'activity status pending, '
    'should call method from workout repository to update workout and '
    'should emit info that activity status has been saved',
    build: () => createBloc(activityStatusType: ActivityStatusType.pending),
    setUp: () => workoutRepository.mockUpdateWorkout(),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusLoading(),
        activityStatusType: ActivityStatusType.pending,
      ),
      const ActivityStatusCreatorState(
        status: BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
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
    'should call method from race repository to update race and '
    'should emit info that activity status has been saved',
    build: () => createBloc(
      activityType: ActivityType.race,
      activityStatusType: ActivityStatusType.pending,
    ),
    setUp: () => raceRepository.mockUpdateRace(),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusLoading(),
        activityStatusType: ActivityStatusType.pending,
      ),
      const ActivityStatusCreatorState(
        status: BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
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
    'should call method from workout repository to update workout and '
    'should emit info that activity status has been saved',
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
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusLoading(),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      const ActivityStatusCreatorState(
        status: BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
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
    'should call method from race repository to update race and '
    'should emit info that activity status has been saved',
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
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusLoading(),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      const ActivityStatusCreatorState(
        status: BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
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
    'should call method from workout repository to update workout and '
    'should emit info that activity status has been saved',
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
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusLoading(),
        activityStatusType: ActivityStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      const ActivityStatusCreatorState(
        status: BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
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
    'should call method from race repository to update race and '
    'should emit info that activity status has been saved',
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
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusLoading(),
        activityStatusType: ActivityStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      const ActivityStatusCreatorState(
        status: BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
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
    'should call method from workout repository to update workout and '
    'should emit info that activity status has been saved',
    build: () => createBloc(activityStatusType: ActivityStatusType.undone),
    setUp: () => workoutRepository.mockUpdateWorkout(),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusLoading(),
        activityStatusType: ActivityStatusType.undone,
      ),
      const ActivityStatusCreatorState(
        status: BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
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
    'should call method from race repository to update race and '
    'should emit info that activity status has been saved',
    build: () => createBloc(
      activityType: ActivityType.race,
      activityStatusType: ActivityStatusType.undone,
    ),
    setUp: () => raceRepository.mockUpdateRace(),
    act: (ActivityStatusCreatorBloc bloc) => bloc.add(
      const ActivityStatusCreatorEventSubmit(),
    ),
    expect: () => [
      const ActivityStatusCreatorState(
        status: BlocStatusLoading(),
        activityStatusType: ActivityStatusType.undone,
      ),
      const ActivityStatusCreatorState(
        status: BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
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
