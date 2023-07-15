part of 'workout_creator_bloc.dart';

class WorkoutCreatorState extends BlocState<WorkoutCreatorState> {
  final Workout? workout;
  final String? workoutName;
  final List<WorkoutStage> stages;

  const WorkoutCreatorState({
    required super.status,
    this.workout,
    this.workoutName,
    required this.stages,
  });

  @override
  List<Object?> get props => [
        status,
        workout,
        workoutName,
        stages,
      ];

  bool get canSubmit =>
      workoutName?.isNotEmpty == true &&
      stages.isNotEmpty &&
      (workout == null ||
          workoutName != workout?.name ||
          _areStagesDifferentThanOriginal());

  @override
  WorkoutCreatorState copyWith({
    BlocStatus? status,
    Workout? workout,
    String? workoutName,
    List<WorkoutStage>? stages,
  }) {
    return WorkoutCreatorState(
      status: status ?? const BlocStatusComplete(),
      workout: workout ?? this.workout,
      workoutName: workoutName ?? this.workoutName,
      stages: stages != null ? [...stages] : this.stages,
    );
  }

  bool _areStagesDifferentThanOriginal() {
    final originalStages = [...?workout?.stages];
    return !areListsEqual(stages, originalStages);
  }
}
