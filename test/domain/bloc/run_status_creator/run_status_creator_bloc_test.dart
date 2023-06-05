import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/run_status_creator/run_status_creator_bloc.dart';
import 'package:runnoter/domain/entity/run_status.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_workout_repository.dart';
import '../../../util/workout_creator.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();

  RunStatusCreatorBloc createBloc({
    String? workoutId,
    RunStatusType? runStatusType,
    double? coveredDistanceInKm,
    MoodRate? moodRate,
    int? averagePaceMinutes,
    int? averagePaceSeconds,
    int? averageHeartRate,
    String? comment,
  }) =>
      RunStatusCreatorBloc(
        authService: authService,
        workoutRepository: workoutRepository,
        workoutId: workoutId,
        runStatusType: runStatusType,
        coveredDistanceInKm: coveredDistanceInKm,
        moodRate: moodRate,
        averagePaceMinutes: averagePaceMinutes,
        averagePaceSeconds: averagePaceSeconds,
        averageHeartRate: averageHeartRate,
        comment: comment,
      );

  RunStatusCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    String? workoutId,
    RunStatus? runStatus,
    RunStatusType? runStatusType,
    double? coveredDistanceInKm,
    MoodRate? moodRate,
    int? averagePaceMinutes,
    int? averagePaceSeconds,
    int? averageHeartRate,
    String? comment,
  }) =>
      RunStatusCreatorState(
        status: status,
        workoutId: workoutId,
        runStatus: runStatus,
        runStatusType: runStatusType,
        coveredDistanceInKm: coveredDistanceInKm,
        moodRate: moodRate,
        averagePaceMinutes: averagePaceMinutes,
        averagePaceSeconds: averagePaceSeconds,
        averageHeartRate: averageHeartRate,
        comment: comment,
      );

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
  });

  blocTest(
    'initialize, '
    'workout status type is not null, '
    'should update workout id and status type in state',
    build: () => createBloc(),
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      RunStatusCreatorEventInitialize(
        workoutId: 'w1',
        runStatusType: RunStatusType.done,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workoutId: 'w1',
        runStatusType: RunStatusType.done,
      ),
    ],
  );

  blocTest(
    'initialize, '
    'workout status type is null, '
    'logged user does not exist, '
    'should emit no logged user status and should end event call',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      RunStatusCreatorEventInitialize(
        workoutId: 'w1',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'workout status type is null, '
    'logged user exists, '
    'workout status contains workout stats, '
    'should load workout from workout repository and should emit completed status with RunStatusCreatorBlocInfo.runStatusInitialized and updated all params relevant to workout status',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          status: RunStatusDone(
            coveredDistanceInKm: 10,
            avgPace: const Pace(minutes: 6, seconds: 10),
            avgHeartRate: 150,
            moodRate: MoodRate.mr8,
            comment: 'comment',
          ),
        ),
      );
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      RunStatusCreatorEventInitialize(
        workoutId: 'w1',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusInitialized,
        ),
        workoutId: 'w1',
        runStatus: RunStatusDone(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
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
          workoutId: 'w1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'workout status type is null, '
    'logged user exists, '
    'pending workout status, '
    'should load workout from workout repository and should emit complete status with RunStatusCreatorBlocInfo.runStatusInitialized, updated workout id and workout status type',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          status: const RunStatusPending(),
        ),
      );
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      RunStatusCreatorEventInitialize(
        workoutId: 'w1',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusInitialized,
        ),
        workoutId: 'w1',
        runStatus: const RunStatusPending(),
        runStatusType: RunStatusType.pending,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutById(
          workoutId: 'w1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'workout status type changed, '
    'should update workout status type in state',
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
    'workout id is null, '
    'should finish event call',
    build: () => createBloc(),
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user info and should end event call',
    build: () => createBloc(
      workoutId: 'w1',
    ),
    setUp: () {
      authService.mockGetLoggedUserId();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        workoutId: 'w1',
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'submit, '
    'pending workout status, '
    'should call method from workout repository to update workout and should emit info that workout has been saved',
    build: () => createBloc(
      workoutId: 'w1',
      runStatusType: RunStatusType.pending,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockUpdateWorkout();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        workoutId: 'w1',
        runStatusType: RunStatusType.pending,
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        workoutId: 'w1',
        runStatusType: RunStatusType.pending,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.updateWorkout(
          workoutId: 'w1',
          userId: 'u1',
          status: const RunStatusPending(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'done workout status, '
    'should call method from workout repository to update workout and should emit info that workout has been saved',
    build: () => createBloc(
      workoutId: 'w1',
      runStatusType: RunStatusType.done,
      coveredDistanceInKm: 10,
      moodRate: MoodRate.mr8,
      averagePaceMinutes: 5,
      averagePaceSeconds: 50,
      averageHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockUpdateWorkout();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        workoutId: 'w1',
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
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
        workoutId: 'w1',
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
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
          workoutId: 'w1',
          userId: 'u1',
          status: RunStatusDone(
            coveredDistanceInKm: 10,
            avgPace: const Pace(minutes: 5, seconds: 50),
            avgHeartRate: 150,
            moodRate: MoodRate.mr8,
            comment: 'comment',
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'aborted workout status, '
    'should call method from workout repository to update workout and should emit info that workout has been saved',
    build: () => createBloc(
      workoutId: 'w1',
      runStatusType: RunStatusType.aborted,
      coveredDistanceInKm: 10,
      moodRate: MoodRate.mr8,
      averagePaceMinutes: 5,
      averagePaceSeconds: 50,
      averageHeartRate: 150,
      comment: 'comment',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockUpdateWorkout();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        workoutId: 'w1',
        runStatusType: RunStatusType.aborted,
        coveredDistanceInKm: 10,
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
        workoutId: 'w1',
        runStatusType: RunStatusType.aborted,
        coveredDistanceInKm: 10,
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
          workoutId: 'w1',
          userId: 'u1',
          status: RunStatusAborted(
            coveredDistanceInKm: 10,
            avgPace: const Pace(minutes: 5, seconds: 50),
            avgHeartRate: 150,
            moodRate: MoodRate.mr8,
            comment: 'comment',
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'undone workout status, '
    'should call method from workout repository to update workout and should emit info that workout has been saved',
    build: () => createBloc(
      workoutId: 'w1',
      runStatusType: RunStatusType.undone,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockUpdateWorkout();
    },
    act: (RunStatusCreatorBloc bloc) => bloc.add(
      const RunStatusCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        workoutId: 'w1',
        runStatusType: RunStatusType.undone,
      ),
      createState(
        status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
          info: RunStatusCreatorBlocInfo.runStatusSaved,
        ),
        workoutId: 'w1',
        runStatusType: RunStatusType.undone,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.updateWorkout(
          workoutId: 'w1',
          userId: 'u1',
          status: const RunStatusUndone(),
        ),
      ).called(1);
    },
  );
}
