part of 'workout_creator_bloc.dart';

class WorkoutCreatorState extends BlocState<WorkoutCreatorState> {
  final DateTime? date;
  final String? workoutId;
  final String? workoutName;
  final List<WorkoutStage> stages;

  const WorkoutCreatorState({
    required super.status,
    required this.date,
    required this.workoutId,
    required this.workoutName,
    required this.stages,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        workoutId,
        workoutName,
        stages,
      ];

  bool get isSubmitButtonDisabled =>
      date == null ||
      workoutName == null ||
      workoutName == '' ||
      stages.isEmpty;

  @override
  WorkoutCreatorState copyWith({
    BlocStatus? status,
    DateTime? date,
    String? workoutId,
    String? workoutName,
    List<WorkoutStage>? stages,
  }) {
    return WorkoutCreatorState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      workoutId: workoutId ?? this.workoutId,
      workoutName: workoutName ?? this.workoutName,
      stages: stages ?? this.stages,
    );
  }
}

enum WorkoutCreatorInfo {
  editModeInitialized,
  workoutAdded,
  workoutUpdated,
}
