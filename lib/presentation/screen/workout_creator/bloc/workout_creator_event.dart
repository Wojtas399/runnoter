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

class WorkoutCreatorWorkoutNameChanged extends WorkoutCreatorEvent {
  final String? workoutName;

  const WorkoutCreatorWorkoutNameChanged({
    required this.workoutName,
  });

  @override
  List<Object?> get props => [
        workoutName,
      ];
}

class WorkoutCreatorWorkoutStageAdded extends WorkoutCreatorEvent {
  final WorkoutStage workoutStage;

  const WorkoutCreatorWorkoutStageAdded({
    required this.workoutStage,
  });

  @override
  List<Object> get props => [
        workoutStage,
      ];
}
