part of 'workout_preview_bloc.dart';

class WorkoutPreviewState extends BlocState<WorkoutPreviewState> {
  final DateTime? date;
  final String? workoutName;
  final List<WorkoutStage>? stages;
  final ActivityStatus? activityStatus;

  const WorkoutPreviewState({
    required super.status,
    this.date,
    this.workoutName,
    this.stages,
    this.activityStatus,
  });

  bool get areDataLoaded =>
      date != null &&
      workoutName != null &&
      stages != null &&
      activityStatus != null;

  @override
  List<Object?> get props => [
        status,
        date,
        workoutName,
        stages,
        activityStatus,
      ];

  @override
  WorkoutPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
    ActivityStatus? activityStatus,
  }) {
    return WorkoutPreviewState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      workoutName: workoutName ?? this.workoutName,
      stages: stages ?? this.stages,
      activityStatus: activityStatus ?? this.activityStatus,
    );
  }
}
