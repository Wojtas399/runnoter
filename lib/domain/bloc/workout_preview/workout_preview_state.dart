part of 'workout_preview_bloc.dart';

class WorkoutPreviewState extends BlocState<WorkoutPreviewState> {
  final DateTime? date;
  final String? workoutName;
  final List<WorkoutStage>? stages;
  final RunStatus? runStatus;

  const WorkoutPreviewState({
    required super.status,
    this.date,
    this.workoutName,
    this.stages,
    this.runStatus,
  });

  bool get areDataLoaded =>
      date != null &&
      workoutName != null &&
      stages != null &&
      runStatus != null;

  @override
  List<Object?> get props => [
        status,
        date,
        workoutName,
        stages,
        runStatus,
      ];

  @override
  WorkoutPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
    RunStatus? runStatus,
  }) {
    return WorkoutPreviewState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      workoutName: workoutName ?? this.workoutName,
      stages: stages ?? this.stages,
      runStatus: runStatus ?? this.runStatus,
    );
  }
}
