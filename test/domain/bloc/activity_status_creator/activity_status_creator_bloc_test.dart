import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/activity_status_creator/activity_status_creator_bloc.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/race_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  const String loggedUserId = 'u1';
  const String entityId = 'e1';

  ActivityStatusCreatorBloc createBloc({
    ActivityStatusCreatorEntityType? entityType,
    String? entityId,
    ActivityStatusType? activityStatusType,
    double? coveredDistanceInKm,
    Duration? duration,
    MoodRate? moodRate,
    Pace? avgPace,
    int? avgHeartRate,
    String? comment,
  }) =>
      ActivityStatusCreatorBloc(
        entityType: entityType,
        entityId: entityId,
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

  ActivityStatusCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    ActivityStatus? originalActivityStatus,
    ActivityStatusType? activityStatusType,
    double? coveredDistanceInKm,
    Duration? duration,
    MoodRate? moodRate,
    Pace? avgPace,
    int? avgHeartRate,
    String? comment,
  }) =>
      ActivityStatusCreatorState(
        status: status,
        originalActivityStatus: originalActivityStatus,
        activityStatusType: activityStatusType,
        coveredDistanceInKm: coveredDistanceInKm,
        duration: duration,
        moodRate: moodRate,
        avgPace: avgPace,
        avgHeartRate: avgHeartRate,
        comment: comment,
      );

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
    registerFallbackValue(const ActivityStatusPending());
  });

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
    reset(raceRepository);
  });

  blocTest(
    'initialize, '
    'entity type is null, '
    'should do nothing',
    build: () => createBloc(entityId: entityId),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'entity id is null, '
    'should do nothing',
    build: () =>
        createBloc(entityType: ActivityStatusCreatorEntityType.workout),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.workout,
      entityId: entityId,
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'workout entity, '
    'activity status contains params, '
    'should load workout from repository and should update all params relevant to activity status',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.workout,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: entityId,
          userId: loggedUserId,
          status: const ActivityStatusDone(
            coveredDistanceInKm: 10,
            duration: Duration(seconds: 2),
            avgPace: Pace(minutes: 6, seconds: 10),
            avgHeartRate: 150,
            moodRate: MoodRate.mr8,
            comment: 'comment',
          ),
        ),
      );
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalActivityStatus: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 2),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 2),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutById(
          workoutId: entityId,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'workout entity, '
    'activity status pending, '
    'should load workout from repository and should set activity status type as done',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.workout,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: entityId,
          userId: loggedUserId,
          status: const ActivityStatusPending(),
        ),
      );
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalActivityStatus: const ActivityStatusPending(),
        activityStatusType: ActivityStatusType.done,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutById(
          workoutId: entityId,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'workout entity, '
    'activity status undone, '
    'should load workout from repository and should set activity status type as undone',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.workout,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: entityId,
          userId: loggedUserId,
          status: const ActivityStatusUndone(),
        ),
      );
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalActivityStatus: const ActivityStatusUndone(),
        activityStatusType: ActivityStatusType.undone,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutById(
          workoutId: entityId,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'race entity, '
    'activity status contains params, '
    'should load race from repository and should update all params relevant to activity status',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.race,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockGetRaceById(
        race: createRace(
          id: entityId,
          userId: loggedUserId,
          status: const ActivityStatusDone(
            coveredDistanceInKm: 10,
            duration: Duration(seconds: 2),
            avgPace: Pace(minutes: 6, seconds: 10),
            avgHeartRate: 150,
            moodRate: MoodRate.mr8,
            comment: 'comment',
          ),
        ),
      );
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalActivityStatus: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 2),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 2),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.getRaceById(
          raceId: entityId,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'race entity, '
    'activity status pending, '
    'should load race from repository and should set activity status type as done',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.race,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockGetRaceById(
        race: createRace(
          id: entityId,
          userId: loggedUserId,
          status: const ActivityStatusPending(),
        ),
      );
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalActivityStatus: const ActivityStatusPending(),
        activityStatusType: ActivityStatusType.done,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.getRaceById(
          raceId: entityId,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'race entity, '
    'activity status undone, '
    'should load race from repository and should set activity status type as undone',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.race,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockGetRaceById(
        race: createRace(
          id: entityId,
          userId: loggedUserId,
          status: const ActivityStatusUndone(),
        ),
      );
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalActivityStatus: const ActivityStatusUndone(),
        activityStatusType: ActivityStatusType.undone,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.getRaceById(
          raceId: entityId,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'activity status type changed, '
    'should update activity status type in state',
    build: () => createBloc(),
    act: (bloc) =>
        bloc.add(const ActivityStatusCreatorEventActivityStatusTypeChanged(
      activityStatusType: ActivityStatusType.done,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
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
      createState(
        status: const BlocStatusComplete(),
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
      createState(
        status: const BlocStatusComplete(),
        duration: const Duration(seconds: 3),
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
      createState(
        status: const BlocStatusComplete(),
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
      createState(
        status: const BlocStatusComplete(),
        avgPace: const Pace(minutes: 6, seconds: 10),
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
      createState(
        status: const BlocStatusComplete(),
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
      createState(
        status: const BlocStatusComplete(),
        comment: 'comment',
      ),
    ],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.workout,
      entityId: entityId,
      activityStatusType: ActivityStatusType.pending,
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        activityStatusType: ActivityStatusType.pending,
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'submit, '
    'workout, '
    'activity status pending, '
    'should call method from workout repository to update workout and should emit info that activity status has been saved',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.workout,
      entityId: entityId,
      activityStatusType: ActivityStatusType.pending,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockUpdateWorkout();
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        activityStatusType: ActivityStatusType.pending,
      ),
      createState(
        status: const BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.pending,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.updateWorkout(
          workoutId: entityId,
          userId: loggedUserId,
          status: const ActivityStatusPending(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'race, '
    'activity status pending, '
    'should call method from race repository to update race and should emit info that activity status has been saved',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.race,
      entityId: entityId,
      activityStatusType: ActivityStatusType.pending,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockUpdateRace();
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        activityStatusType: ActivityStatusType.pending,
      ),
      createState(
        status: const BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.pending,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.updateRace(
          raceId: entityId,
          userId: loggedUserId,
          status: const ActivityStatusPending(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'workout, '
    'activity status done, '
    'should call method from workout repository to update workout and should emit info that activity status has been saved',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.workout,
      entityId: entityId,
      activityStatusType: ActivityStatusType.done,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      avgPace: const Pace(minutes: 5, seconds: 50),
      avgHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockUpdateWorkout();
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      createState(
        status: const BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.updateWorkout(
          workoutId: entityId,
          userId: loggedUserId,
          status: const ActivityStatusDone(
            coveredDistanceInKm: 10,
            duration: Duration(seconds: 3),
            moodRate: MoodRate.mr8,
            avgPace: Pace(minutes: 5, seconds: 50),
            avgHeartRate: 150,
            comment: 'comment',
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'race, '
    'activity status done, '
    'should call method from race repository to update race and should emit info that activity status has been saved',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.race,
      entityId: entityId,
      activityStatusType: ActivityStatusType.done,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      avgPace: const Pace(minutes: 5, seconds: 50),
      avgHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockUpdateRace();
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      createState(
        status: const BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.updateRace(
          raceId: entityId,
          userId: loggedUserId,
          status: const ActivityStatusDone(
            coveredDistanceInKm: 10,
            duration: Duration(seconds: 3),
            moodRate: MoodRate.mr8,
            avgPace: Pace(minutes: 5, seconds: 50),
            avgHeartRate: 150,
            comment: 'comment',
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'workout, '
    'activity status aborted, '
    'should call method from workout repository to update workout and should emit info that activity status has been saved',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.workout,
      entityId: entityId,
      activityStatusType: ActivityStatusType.aborted,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      avgPace: const Pace(minutes: 5, seconds: 50),
      avgHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockUpdateWorkout();
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        activityStatusType: ActivityStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      createState(
        status: const BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.updateWorkout(
          workoutId: entityId,
          userId: loggedUserId,
          status: const ActivityStatusAborted(
            coveredDistanceInKm: 10,
            duration: Duration(seconds: 3),
            moodRate: MoodRate.mr8,
            avgPace: Pace(minutes: 5, seconds: 50),
            avgHeartRate: 150,
            comment: 'comment',
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'race, '
    'activity status aborted, '
    'should call method from race repository to update race and should emit info that activity status has been saved',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.race,
      entityId: entityId,
      activityStatusType: ActivityStatusType.aborted,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      avgPace: const Pace(minutes: 5, seconds: 50),
      avgHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockUpdateRace();
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        activityStatusType: ActivityStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      createState(
        status: const BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.updateRace(
          raceId: entityId,
          userId: loggedUserId,
          status: const ActivityStatusAborted(
            coveredDistanceInKm: 10,
            duration: Duration(seconds: 3),
            moodRate: MoodRate.mr8,
            avgPace: Pace(minutes: 5, seconds: 50),
            avgHeartRate: 150,
            comment: 'comment',
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'workout, '
    'activity status undone, '
    'should call method from workout repository to update workout and should emit info that activity status has been saved',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.workout,
      entityId: entityId,
      activityStatusType: ActivityStatusType.undone,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockUpdateWorkout();
    },
    act: (bloc) => bloc.add(const ActivityStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        activityStatusType: ActivityStatusType.undone,
      ),
      createState(
        status: const BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.undone,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.updateWorkout(
          workoutId: entityId,
          userId: loggedUserId,
          status: const ActivityStatusUndone(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'race, '
    'activity status undone, '
    'should call method from race repository to update race and should emit info that activity status has been saved',
    build: () => createBloc(
      entityType: ActivityStatusCreatorEntityType.race,
      entityId: entityId,
      activityStatusType: ActivityStatusType.undone,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockUpdateRace();
    },
    act: (ActivityStatusCreatorBloc bloc) => bloc.add(
      const ActivityStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        activityStatusType: ActivityStatusType.undone,
      ),
      createState(
        status: const BlocStatusComplete<ActivityStatusCreatorBlocInfo>(
          info: ActivityStatusCreatorBlocInfo.activityStatusSaved,
        ),
        activityStatusType: ActivityStatusType.undone,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.updateRace(
          raceId: entityId,
          userId: loggedUserId,
          status: const ActivityStatusUndone(),
        ),
      ).called(1);
    },
  );
}
