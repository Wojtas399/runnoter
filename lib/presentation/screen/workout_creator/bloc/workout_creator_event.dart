import 'package:equatable/equatable.dart';

import '../../../../domain/model/workout_stage.dart';

abstract class WorkoutCreatorEvent extends Equatable {
  const WorkoutCreatorEvent();
}

class WorkoutCreatorEventInitialize extends WorkoutCreatorEvent {
  final DateTime date;

  const WorkoutCreatorEventInitialize({
    required this.date,
  });

  @override
  List<Object> get props => [date];
}

class WorkoutCreatorEventWorkoutNameChanged extends WorkoutCreatorEvent {
  final String? workoutName;

  const WorkoutCreatorEventWorkoutNameChanged({
    required this.workoutName,
  });

  @override
  List<Object?> get props => [
        workoutName,
      ];
}

class WorkoutCreatorEventWorkoutStageAdded extends WorkoutCreatorEvent {
  final WorkoutStage workoutStage;

  const WorkoutCreatorEventWorkoutStageAdded({
    required this.workoutStage,
  });

  @override
  List<Object> get props => [
        workoutStage,
      ];
}
