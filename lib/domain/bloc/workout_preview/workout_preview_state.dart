part of 'workout_preview_bloc.dart';

class WorkoutPreviewState extends BlocState<WorkoutPreviewState> {
  final DateTime? date;
  final bool? isPastDay;
  final String? workoutId;
  final String? workoutName;
  final List<WorkoutStage>? stages;
  final RunStatus? runStatus;

  const WorkoutPreviewState({
    required super.status,
    this.date,
    this.isPastDay,
    this.workoutId,
    this.workoutName,
    this.stages,
    this.runStatus,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        isPastDay,
        workoutId,
        workoutName,
        stages,
        runStatus,
      ];

  @override
  WorkoutPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    bool? isPastDay,
    String? workoutId,
    bool workoutIdAsNull = false,
    String? workoutName,
    List<WorkoutStage>? stages,
    RunStatus? runStatus,
  }) {
    return WorkoutPreviewState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      isPastDay: isPastDay ?? this.isPastDay,
      workoutId: workoutIdAsNull ? null : workoutId ?? this.workoutId,
      workoutName: workoutName ?? this.workoutName,
      stages: stages ?? this.stages,
      runStatus: runStatus ?? this.runStatus,
    );
  }
}
