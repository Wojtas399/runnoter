import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_status_creator/bloc/workout_status_creator_bloc.dart';

void main() {
  WorkoutStatusCreatorBloc createBloc() => WorkoutStatusCreatorBloc();

  WorkoutStatusCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    WorkoutStatusType? workoutStatusType,
    double? coveredDistanceInKm,
  }) =>
      WorkoutStatusCreatorState(
        status: status,
        workoutStatusType: workoutStatusType,
        coveredDistanceInKm: coveredDistanceInKm,
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
}
