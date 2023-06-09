import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/run_status_creator/run_status_creator_bloc.dart';
import 'package:runnoter/domain/entity/run_status.dart';

import '../../../creators/competition_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_competition_repository.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  const String entityId = 'e1';
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  final competitionRepository = MockCompetitionRepository();
  const String userId = 'u1';

  RunStatusCreatorBloc createBloc({
    EntityType entityType = EntityType.workout,
    RunStatusType? runStatusType,
    double? coveredDistanceInKm,
    Duration? duration,
    MoodRate? moodRate,
    int? averagePaceMinutes,
    int? averagePaceSeconds,
    int? averageHeartRate,
    String? comment,
  }) =>
      RunStatusCreatorBloc(
        entityType: entityType,
        entityId: entityId,
        authService: authService,
        workoutRepository: workoutRepository,
        competitionRepository: competitionRepository,
        state: RunStatusCreatorState(
          status: const BlocStatusInitial(),
          entityType: entityType,
          runStatusType: runStatusType,
          coveredDistanceInKm: coveredDistanceInKm,
          duration: duration,
          moodRate: moodRate,
          averagePaceMinutes: averagePaceMinutes,
          averagePaceSeconds: averagePaceSeconds,
          averageHeartRate: averageHeartRate,
          comment: comment,
        ),
      );

  RunStatusCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    EntityType entityType = EntityType.workout,
    RunStatus? originalRunStatus,
    RunStatusType? runStatusType,
    double? coveredDistanceInKm,
    Duration? duration,
    MoodRate? moodRate,
    int? averagePaceMinutes,
    int? averagePaceSeconds,
    int? averageHeartRate,
    String? comment,
  }) =>
      RunStatusCreatorState(
        status: status,
        entityType: entityType,
        originalRunStatus: originalRunStatus,
        runStatusType: runStatusType,
        coveredDistanceInKm: coveredDistanceInKm,
        duration: duration,
        moodRate: moodRate,
        averagePaceMinutes: averagePaceMinutes,
        averagePaceSeconds: averagePaceSeconds,
        averageHeartRate: averageHeartRate,
        comment: comment,
      );

  setUpAll(() {
    registerFallbackValue(
      const RunStatusPending(),
    );
  });

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
    reset(competitionRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'workout entity, '
    'run status contains params, '
    'should load workout from repository and should update all params relevant to run status',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: entityId,
          userId: userId,
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
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusInitialized,
        ),
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
        averagePaceMinutes: 6,
        averagePaceSeconds: 10,
        averageHeartRate: 150,
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
          userId: userId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'workout entity, '
    'run status pending, '
    'should load workout from repository and should set run status type as done',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: entityId,
          userId: userId,
          status: const RunStatusPending(),
        ),
      );
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusInitialized,
        ),
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
          userId: userId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'workout entity, '
    'run status undone, '
    'should load workout from repository and should set run status type as undone',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: entityId,
          userId: userId,
          status: const RunStatusUndone(),
        ),
      );
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusInitialized,
        ),
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
          userId: userId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'competition entity, '
    'run status contains params, '
    'should load competition from repository and should update all params relevant to run status',
    build: () => createBloc(
      entityType: EntityType.competition,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      competitionRepository.mockGetCompetitionById(
        competition: createCompetition(
          id: entityId,
          userId: userId,
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
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusInitialized,
        ),
        entityType: EntityType.competition,
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
        duration: Duration(seconds: 2),
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 6,
        averagePaceSeconds: 10,
        averageHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.getCompetitionById(
          competitionId: entityId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'competition entity, '
    'run status pending, '
    'should load competition from repository and should set run status type as done',
    build: () => createBloc(
      entityType: EntityType.competition,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      competitionRepository.mockGetCompetitionById(
        competition: createCompetition(
          id: entityId,
          userId: userId,
          status: const RunStatusPending(),
        ),
      );
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusInitialized,
        ),
        entityType: EntityType.competition,
        originalRunStatus: const RunStatusPending(),
        runStatusType: RunStatusType.done,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.getCompetitionById(
          competitionId: entityId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'competition entity, '
    'run status undone, '
    'should load competition from repository and should set run status type as undone',
    build: () => createBloc(
      entityType: EntityType.competition,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      competitionRepository.mockGetCompetitionById(
        competition: createCompetition(
          id: entityId,
          userId: userId,
          status: const RunStatusUndone(),
        ),
      );
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusInitialized,
        ),
        entityType: EntityType.competition,
        originalRunStatus: const RunStatusUndone(),
        runStatusType: RunStatusType.undone,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.getCompetitionById(
          competitionId: entityId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'run status type changed, '
    'should update run status type in state',
    build: () => createBloc(),
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventRunStatusTypeChanged(
        runStatusType: RunStatusType.done,
      ),
    ),
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
    act: (RunStatusCreatorBloc bloc) => bloc.add(
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
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventDurationChanged(
        duration: Duration(seconds: 3),
      ),
    ),
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
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventMoodRateChanged(
        moodRate: MoodRate.mr8,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        moodRate: MoodRate.mr8,
      ),
    ],
  );

  blocTest(
    'avg pace minutes changed, '
    'should update average pace minutes in state',
    build: () => createBloc(),
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventAvgPaceMinutesChanged(
        minutes: 6,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        averagePaceMinutes: 6,
      ),
    ],
  );

  blocTest(
    'avg pace seconds changed, '
    'should update average pace seconds in state',
    build: () => createBloc(),
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventAvgPaceSecondsChanged(
        seconds: 2,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        averagePaceSeconds: 2,
      ),
    ],
  );

  blocTest(
    'avg heart rate changed, '
    'should update average heart rate in state',
    build: () => createBloc(),
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventAvgHeartRateChanged(
        averageHeartRate: 150,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        averageHeartRate: 150,
      ),
    ],
  );

  blocTest(
    'comment changed, ',
    build: () => createBloc(),
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventCommentChanged(
        comment: 'comment',
      ),
    ),
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
      runStatusType: RunStatusType.pending,
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
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
    'run status pending, '
    'workout, '
    'should call method from workout repository to update workout and should emit info that run status has been saved',
    build: () => createBloc(
      runStatusType: RunStatusType.pending,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      workoutRepository.mockUpdateWorkout();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
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
          userId: userId,
          status: const RunStatusPending(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'run status pending, '
    'competition, '
    'should call method from competition repository to update competition and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: EntityType.competition,
      runStatusType: RunStatusType.pending,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      competitionRepository.mockUpdateCompetition();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        entityType: EntityType.competition,
        runStatusType: RunStatusType.pending,
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        entityType: EntityType.competition,
        runStatusType: RunStatusType.pending,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.updateCompetition(
          competitionId: entityId,
          userId: userId,
          status: const RunStatusPending(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'run status done, '
    'workout, '
    'should call method from workout repository to update workout and should emit info that run status has been saved',
    build: () => createBloc(
      runStatusType: RunStatusType.done,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      averagePaceMinutes: 5,
      averagePaceSeconds: 50,
      averageHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      workoutRepository.mockUpdateWorkout();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averagePaceSeconds: 50,
        averageHeartRate: 150,
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
        averagePaceMinutes: 5,
        averagePaceSeconds: 50,
        averageHeartRate: 150,
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
          userId: userId,
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
    'run status done, '
    'competition, '
    'should call method from competition repository to update competition and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: EntityType.competition,
      runStatusType: RunStatusType.done,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      averagePaceMinutes: 5,
      averagePaceSeconds: 50,
      averageHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      competitionRepository.mockUpdateCompetition();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        entityType: EntityType.competition,
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averagePaceSeconds: 50,
        averageHeartRate: 150,
        comment: 'comment',
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        entityType: EntityType.competition,
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averagePaceSeconds: 50,
        averageHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.updateCompetition(
          competitionId: entityId,
          userId: userId,
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
    'run status aborted, '
    'workout, '
    'should call method from workout repository to update workout and should emit info that run status has been saved',
    build: () => createBloc(
      runStatusType: RunStatusType.aborted,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      averagePaceMinutes: 5,
      averagePaceSeconds: 50,
      averageHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      workoutRepository.mockUpdateWorkout();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        runStatusType: RunStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averagePaceSeconds: 50,
        averageHeartRate: 150,
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
        averagePaceMinutes: 5,
        averagePaceSeconds: 50,
        averageHeartRate: 150,
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
          userId: userId,
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
    'run status aborted, '
    'competition, '
    'should call method from competition repository to update competition and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: EntityType.competition,
      runStatusType: RunStatusType.aborted,
      coveredDistanceInKm: 10,
      duration: const Duration(seconds: 3),
      moodRate: MoodRate.mr8,
      averagePaceMinutes: 5,
      averagePaceSeconds: 50,
      averageHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      competitionRepository.mockUpdateCompetition();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        entityType: EntityType.competition,
        runStatusType: RunStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averagePaceSeconds: 50,
        averageHeartRate: 150,
        comment: 'comment',
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        entityType: EntityType.competition,
        runStatusType: RunStatusType.aborted,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 3),
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averagePaceSeconds: 50,
        averageHeartRate: 150,
        comment: 'comment',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.updateCompetition(
          competitionId: entityId,
          userId: userId,
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
    'run status undone, '
    'workout, '
    'should call method from workout repository to update workout and should emit info that run status has been saved',
    build: () => createBloc(
      runStatusType: RunStatusType.undone,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      workoutRepository.mockUpdateWorkout();
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
        () => workoutRepository.updateWorkout(
          workoutId: entityId,
          userId: userId,
          status: const RunStatusUndone(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'run status undone, '
    'competition, '
    'should call method from competition repository to update competition and should emit info that run status has been saved',
    build: () => createBloc(
      entityType: EntityType.competition,
      runStatusType: RunStatusType.undone,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      competitionRepository.mockUpdateCompetition();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        entityType: EntityType.competition,
        runStatusType: RunStatusType.undone,
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        entityType: EntityType.competition,
        runStatusType: RunStatusType.undone,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.updateCompetition(
          competitionId: entityId,
          userId: userId,
          status: const RunStatusUndone(),
        ),
      ).called(1);
    },
  );
}
