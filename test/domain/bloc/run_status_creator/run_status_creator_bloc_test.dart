import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/run_status_creator/run_status_creator_bloc.dart';
import 'package:runnoter/domain/entity/run_status.dart';
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

  RunStatusCreatorBloc createBloc({
    RunStatusCreatorEntityType? entityType,
    String? entityId,
    RunStatusType? runStatusType,
    double? coveredDistanceInKm,
    Duration? duration,
    MoodRate? moodRate,
    Pace? avgPace,
    int? avgHeartRate,
    String? comment,
  }) =>
      RunStatusCreatorBloc(
        raceRepository: raceRepository,
        entityType: entityType,
        entityId: entityId,
        state: RunStatusCreatorState(
          status: const BlocStatusInitial(),
          runStatusType: runStatusType,
          coveredDistanceInKm: coveredDistanceInKm,
          duration: duration,
          moodRate: moodRate,
          avgPace: avgPace,
          avgHeartRate: avgHeartRate,
          comment: comment,
        ),
      );

  RunStatusCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    RunStatus? originalRunStatus,
    RunStatusType? runStatusType,
    double? coveredDistanceInKm,
    Duration? duration,
    MoodRate? moodRate,
    Pace? avgPace,
    int? avgHeartRate,
    String? comment,
  }) =>
      RunStatusCreatorState(
        status: status,
        originalRunStatus: originalRunStatus,
        runStatusType: runStatusType,
        coveredDistanceInKm: coveredDistanceInKm,
        duration: duration,
        moodRate: moodRate,
        avgPace: avgPace,
        avgHeartRate: avgHeartRate,
        comment: comment,
      );

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    registerFallbackValue(const RunStatusPending());
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventInitialize()),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'entity id is null, '
    'should do nothing',
    build: () => createBloc(entityType: RunStatusCreatorEntityType.workout),
    act: (bloc) => bloc.add(const RunStatusCreatorEventInitialize()),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.workout,
      entityId: entityId,
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const RunStatusCreatorEventInitialize()),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'workout entity, '
    'run status contains params, '
    'should load workout from repository and should update all params relevant to run status',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.workout,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: entityId,
          userId: loggedUserId,
          status: const RunStatusDone(
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalRunStatus: const RunStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 2),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
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
    'run status pending, '
    'should load workout from repository and should set run status type as done',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.workout,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: entityId,
          userId: loggedUserId,
          status: const RunStatusPending(),
        ),
      );
    },
    act: (bloc) => bloc.add(const RunStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalRunStatus: const RunStatusPending(),
        runStatusType: RunStatusType.done,
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
    'run status undone, '
    'should load workout from repository and should set run status type as undone',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.workout,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: entityId,
          userId: loggedUserId,
          status: const RunStatusUndone(),
        ),
      );
    },
    act: (bloc) => bloc.add(const RunStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalRunStatus: const RunStatusUndone(),
        runStatusType: RunStatusType.undone,
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
    'run status contains params, '
    'should load race from repository and should update all params relevant to run status',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.race,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockGetRaceById(
        race: createRace(
          id: entityId,
          userId: loggedUserId,
          status: const RunStatusDone(
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalRunStatus: const RunStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 2),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
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
    'run status pending, '
    'should load race from repository and should set run status type as done',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.race,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockGetRaceById(
        race: createRace(
          id: entityId,
          userId: loggedUserId,
          status: const RunStatusPending(),
        ),
      );
    },
    act: (bloc) => bloc.add(const RunStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalRunStatus: const RunStatusPending(),
        runStatusType: RunStatusType.done,
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
    'run status undone, '
    'should load race from repository and should set run status type as undone',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.race,
      entityId: entityId,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockGetRaceById(
        race: createRace(
          id: entityId,
          userId: loggedUserId,
          status: const RunStatusUndone(),
        ),
      );
    },
    act: (bloc) => bloc.add(const RunStatusCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalRunStatus: const RunStatusUndone(),
        runStatusType: RunStatusType.undone,
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
    'run status type changed, '
    'should update run status type in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const RunStatusCreatorEventRunStatusTypeChanged(
      runStatusType: RunStatusType.done,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        runStatusType: RunStatusType.done,
      ),
    ],
  );

  blocTest(
    'covered distance in km changed, '
    'should update covered distance in km in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(
      const RunStatusCreatorEventCoveredDistanceInKmChanged(
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventDurationChanged(
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventMoodRateChanged(
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventAvgPaceChanged(
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventAvgHeartRateChanged(
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventCommentChanged(
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
      entityType: RunStatusCreatorEntityType.workout,
      entityId: entityId,
      runStatusType: RunStatusType.pending,
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const RunStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        runStatusType: RunStatusType.pending,
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'submit, '
    'workout, '
    'run status pending, '
    'should call method from workout repository to update workout and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.workout,
      entityId: entityId,
      runStatusType: RunStatusType.pending,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockUpdateWorkout();
    },
    act: (bloc) => bloc.add(const RunStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        runStatusType: RunStatusType.pending,
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        runStatusType: RunStatusType.pending,
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
          status: const RunStatusPending(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'race, '
    'run status pending, '
    'should call method from race repository to update race and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.race,
      entityId: entityId,
      runStatusType: RunStatusType.pending,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockUpdateRace();
    },
    act: (bloc) => bloc.add(const RunStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        runStatusType: RunStatusType.pending,
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        runStatusType: RunStatusType.pending,
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
          status: const RunStatusPending(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'workout, '
    'run status done, '
    'should call method from workout repository to update workout and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.workout,
      entityId: entityId,
      runStatusType: RunStatusType.done,
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        runStatusType: RunStatusType.done,
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
          status: const RunStatusDone(
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
    'run status done, '
    'should call method from race repository to update race and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.race,
      entityId: entityId,
      runStatusType: RunStatusType.done,
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        runStatusType: RunStatusType.done,
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
          status: const RunStatusDone(
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
    'run status aborted, '
    'should call method from workout repository to update workout and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.workout,
      entityId: entityId,
      runStatusType: RunStatusType.aborted,
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        runStatusType: RunStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        runStatusType: RunStatusType.aborted,
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
          status: const RunStatusAborted(
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
    'run status aborted, '
    'should call method from race repository to update race and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.race,
      entityId: entityId,
      runStatusType: RunStatusType.aborted,
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
    act: (bloc) => bloc.add(const RunStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        runStatusType: RunStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 150,
        comment: 'comment',
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        runStatusType: RunStatusType.aborted,
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
          status: const RunStatusAborted(
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
    'run status undone, '
    'should call method from workout repository to update workout and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.workout,
      entityId: entityId,
      runStatusType: RunStatusType.undone,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockUpdateWorkout();
    },
    act: (bloc) => bloc.add(const RunStatusCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        runStatusType: RunStatusType.undone,
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        runStatusType: RunStatusType.undone,
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
          status: const RunStatusUndone(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'race, '
    'run status undone, '
    'should call method from race repository to update race and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: RunStatusCreatorEntityType.race,
      entityId: entityId,
      runStatusType: RunStatusType.undone,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockUpdateRace();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        runStatusType: RunStatusType.undone,
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        runStatusType: RunStatusType.undone,
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
          status: const RunStatusUndone(),
        ),
      ).called(1);
    },
  );
}
