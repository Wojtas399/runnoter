part of 'workout_creator_bloc.dart';

class WorkoutCreatorState extends BlocState<WorkoutCreatorState> {
  final WorkoutCreatorMode creatorMode;
  final DateTime? date;
  final String? workoutName;
  final List<WorkoutStage> stages;

  const WorkoutCreatorState({
    required super.status,
    required this.creatorMode,
    required this.date,
    required this.workoutName,
    required this.stages,
  });

  @override
  List<Object?> get props => [
        status,
        creatorMode,
        date,
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
    WorkoutCreatorMode? creatorMode,
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
  }) {
    return WorkoutCreatorState(
      status: status ?? const BlocStatusComplete(),
      creatorMode: creatorMode ?? this.creatorMode,
      date: date ?? this.date,
      workoutName: workoutName ?? this.workoutName,
      stages: stages ?? this.stages,
    );
  }
}

enum WorkoutCreatorMode {
  add,
  edit,
}

enum WorkoutCreatorInfo {
  workoutHasBeenAdded,
}
