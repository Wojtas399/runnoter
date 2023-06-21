part of 'day_preview_bloc.dart';

class DayPreviewState extends BlocState<DayPreviewState> {
  final DateTime? date;
  final bool? isPastDay;
  final String? workoutId;
  final String? workoutName;
  final List<WorkoutStage>? stages;
  final RunStatus? runStatus;

  const DayPreviewState({
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
  DayPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    bool? isPastDay,
    String? workoutId,
    bool workoutIdAsNull = false,
    String? workoutName,
    List<WorkoutStage>? stages,
    RunStatus? runStatus,
  }) {
    return DayPreviewState(
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
