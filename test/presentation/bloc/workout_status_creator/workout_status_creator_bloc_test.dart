import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/domain/model/workout_status.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_status_creator/bloc/workout_status_creator_bloc.dart';

void main() {
  WorkoutStatusCreatorBloc createBloc({
    Pace? averagePace,
  }) =>
      WorkoutStatusCreatorBloc(
        averagePace: averagePace,
      );

  WorkoutStatusCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    WorkoutStatusType? workoutStatusType,
    double? coveredDistanceInKm,
    MoodRate? moodRate,
    Pace? averagePace,
    int? averageHeartRate,
    String? comment,
  }) =>
      WorkoutStatusCreatorState(
        status: status,
        workoutStatusType: workoutStatusType,
        coveredDistanceInKm: coveredDistanceInKm,
        moodRate: moodRate,
        averagePace: averagePace,
        averageHeartRate: averageHeartRate,
        comment: comment,
      );

  blocTest(
    'workout status type changed, '
    'should update workout status type in state',
    build: () => createBloc(),
    act: (WorkoutStatusCreatorBloc bloc) => bloc.add(
      const WorkoutStatusCreatorEventWorkoutStatusTypeChanged(
        workoutStatusType: WorkoutStatusType.completed,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workoutStatusType: WorkoutStatusType.completed,
      ),
    ],
  );

  blocTest(
    'covered distance in km changed, '
    'should update covered distance in km in state',
    build: () => createBloc(),
    act: (WorkoutStatusCreatorBloc bloc) => bloc.add(
      const WorkoutStatusCreatorEventCoveredDistanceInKmChanged(
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
    act: (WorkoutStatusCreatorBloc bloc) => bloc.add(
      const WorkoutStatusCreatorEventMoodRateChanged(
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
    'average pace is null, '
    'should set average pace with given minutes and seconds set as 0',
    build: () => createBloc(),
    act: (WorkoutStatusCreatorBloc bloc) => bloc.add(
      const WorkoutStatusCreatorEventAvgPaceMinutesChanged(
        minutes: 6,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        averagePace: const Pace(minutes: 6, seconds: 0),
      ),
    ],
  );

  blocTest(
    'avg pace minutes changed, '
    'average pace is not null, '
    'should update minutes of average pace',
    build: () => createBloc(
      averagePace: const Pace(minutes: 7, seconds: 10),
    ),
    act: (WorkoutStatusCreatorBloc bloc) => bloc.add(
      const WorkoutStatusCreatorEventAvgPaceMinutesChanged(
        minutes: 6,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        averagePace: const Pace(minutes: 6, seconds: 10),
      ),
    ],
  );

  blocTest(
    'avg pace seconds changed, '
    'average pace is null, '
    'should set average pace with given seconds and minutes set as 0',
    build: () => createBloc(),
    act: (WorkoutStatusCreatorBloc bloc) => bloc.add(
      const WorkoutStatusCreatorEventAvgPaceSecondsChanged(
        seconds: 50,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        averagePace: const Pace(minutes: 0, seconds: 50),
      ),
    ],
  );

  blocTest(
    'avg pace seconds changed, '
    'average pace is not null, '
    'should update seconds of average pace',
    build: () => createBloc(
      averagePace: const Pace(minutes: 7, seconds: 10),
    ),
    act: (WorkoutStatusCreatorBloc bloc) => bloc.add(
      const WorkoutStatusCreatorEventAvgPaceSecondsChanged(
        seconds: 2,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        averagePace: const Pace(minutes: 7, seconds: 2),
      ),
    ],
  );

  blocTest(
    'avg heart rate changed, '
    'should update average heart rate in state',
    build: () => createBloc(),
    act: (WorkoutStatusCreatorBloc bloc) => bloc.add(
      const WorkoutStatusCreatorEventAvgHeartRateChanged(
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
    act: (WorkoutStatusCreatorBloc bloc) => bloc.add(
      const WorkoutStatusCreatorEventCommentChanged(
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
}
