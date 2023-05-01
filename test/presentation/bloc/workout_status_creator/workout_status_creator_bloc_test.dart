import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_status_creator/bloc/workout_status_creator_bloc.dart';

void main() {
  WorkoutStatusCreatorBloc createBloc() => WorkoutStatusCreatorBloc();

  WorkoutStatusCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    WorkoutStatusType? workoutStatusType,
  }) =>
      WorkoutStatusCreatorState(
        status: status,
        workoutStatusType: workoutStatusType,
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
}
