import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/workout_stage.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'workout_creator_event.dart';
import 'workout_creator_state.dart';

class WorkoutCreatorBloc extends BlocWithStatus<WorkoutCreatorEvent,
    WorkoutCreatorState, dynamic, dynamic> {
  WorkoutCreatorBloc({
    BlocStatus status = const BlocStatusComplete(),
    DateTime? date,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  }) : super(
          WorkoutCreatorState(
            status: status,
            date: date,
            workoutName: workoutName,
            stages: stages,
          ),
        ) {
    on<WorkoutCreatorEventInitialize>(_initialize);
    on<WorkoutCreatorEventWorkoutNameChanged>(_workoutNameChanged);
    on<WorkoutCreatorEventWorkoutStageAdded>(_workoutStageAdded);
  }

  void _initialize(
    WorkoutCreatorEventInitialize event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    emit(state.copyWith(
      date: event.date,
    ));
  }

  void _workoutNameChanged(
    WorkoutCreatorEventWorkoutNameChanged event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    emit(state.copyWith(
      workoutName: event.workoutName,
    ));
  }

  void _workoutStageAdded(
    WorkoutCreatorEventWorkoutStageAdded event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    emit(state.copyWith(
      stages: [
        ...state.stages,
        event.workoutStage,
      ],
    ));
  }
}
