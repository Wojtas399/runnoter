part of 'workout_preview_cubit.dart';

class WorkoutPreviewState extends Equatable {
  final DateTime? date;
  final String? workoutName;
  final List<WorkoutStage>? stages;
  final ActivityStatus? activityStatus;

  const WorkoutPreviewState({
    this.date,
    this.workoutName,
    this.stages,
    this.activityStatus,
  });

  bool get isWorkoutLoaded =>
      date != null &&
      workoutName != null &&
      stages != null &&
      activityStatus != null;

  @override
  List<Object?> get props => [date, workoutName, stages, activityStatus];

  WorkoutPreviewState copyWith({
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
    ActivityStatus? activityStatus,
  }) =>
      WorkoutPreviewState(
        date: date ?? this.date,
        workoutName: workoutName ?? this.workoutName,
        stages: stages ?? this.stages,
        activityStatus: activityStatus ?? this.activityStatus,
      );
}
