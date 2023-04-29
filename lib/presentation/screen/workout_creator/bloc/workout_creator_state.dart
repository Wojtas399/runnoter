part of 'workout_creator_bloc.dart';

class WorkoutCreatorState extends BlocState<WorkoutCreatorState> {
  final DateTime? date;
  final Workout? workout;
  final String? workoutName;
  final List<WorkoutStage> stages;

  const WorkoutCreatorState({
    required super.status,
    required this.date,
    required this.workout,
    required this.workoutName,
    required this.stages,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        workout,
        workoutName,
        stages,
      ];

  bool get isSubmitButtonDisabled =>
      date == null ||
      _isWorkoutNameInvalid() ||
      stages.isEmpty ||
      (workout != null &&
          _isWorkoutNameSameAsOriginal() &&
          _areStagesSameAsOriginal());

  @override
  WorkoutCreatorState copyWith({
    BlocStatus? status,
    DateTime? date,
    Workout? workout,
    String? workoutName,
    List<WorkoutStage>? stages,
  }) {
    return WorkoutCreatorState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      workout: workout ?? this.workout,
      workoutName: workoutName ?? this.workoutName,
      stages: stages ?? this.stages,
    );
  }

  bool _isWorkoutNameInvalid() => workoutName == null || workoutName == '';

  bool _isWorkoutNameSameAsOriginal() => workoutName == workout?.name;

  bool _areStagesSameAsOriginal() {
    final originalStages = [...?workout?.stages];
    return areListsEqual(stages, originalStages);
  }
}

enum WorkoutCreatorInfo {
  editModeInitialized,
  workoutAdded,
  workoutUpdated,
}
