part of 'workout_creator_bloc.dart';

class WorkoutCreatorState extends BlocState<WorkoutCreatorState> {
  final DateTime? date;
  final String? workoutName;
  final List<WorkoutStage> stages;

  const WorkoutCreatorState({
    required super.status,
    required this.date,
    required this.workoutName,
    required this.stages,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        workoutName,
        stages,
      ];

  @override
  WorkoutCreatorState copyWith({
    BlocStatus? status,
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
  }) {
    return WorkoutCreatorState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      workoutName: workoutName ?? this.workoutName,
      stages: stages ?? this.stages,
    );
  }
}

enum WorkoutCreatorInfo {
  workoutHasBeenAdded,
}
