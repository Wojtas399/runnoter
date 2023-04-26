import '../../../../domain/model/workout_stage.dart';
import '../../../../domain/model/workout_status.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class DayPreviewState extends BlocState<DayPreviewState> {
  final DateTime? date;
  final String? workoutName;
  final List<WorkoutStage>? stages;
  final WorkoutStatus? workoutStatus;

  const DayPreviewState({
    required super.status,
    this.date,
    this.workoutName,
    this.stages,
    this.workoutStatus,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        workoutName,
        stages,
        workoutStatus,
      ];

  bool get doesWorkoutExist =>
      workoutName != null && stages != null && workoutStatus != null;

  @override
  DayPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
    WorkoutStatus? workoutStatus,
  }) {
    return DayPreviewState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      workoutName: workoutName ?? this.workoutName,
      stages: stages ?? this.stages,
      workoutStatus: workoutStatus ?? this.workoutStatus,
    );
  }
}
