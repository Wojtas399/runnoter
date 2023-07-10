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

  bool get canSubmit =>
      date != null &&
      workoutName?.isNotEmpty == true &&
      stages.isNotEmpty &&
      (workout == null ||
          workoutName != workout?.name ||
          _areStagesDifferentThanOriginal());

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
      stages: stages != null ? [...stages] : this.stages,
    );
  }

  bool _areStagesDifferentThanOriginal() {
    final originalStages = [...?workout?.stages];
    return !areListsEqual(stages, originalStages);
  }
}
