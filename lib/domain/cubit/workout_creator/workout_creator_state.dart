part of 'workout_creator_cubit.dart';

class WorkoutCreatorState extends CubitState<WorkoutCreatorState> {
  final DateService _dateService;
  final DateTime? date;
  final Workout? workout;
  final String? workoutName;
  final List<WorkoutStage> stages;

  const WorkoutCreatorState({
    required DateService dateService,
    required super.status,
    this.date,
    this.workout,
    this.workoutName,
    required this.stages,
  }) : _dateService = dateService;

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
          _isDateDifferentThanOriginal() ||
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
      dateService: _dateService,
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      workout: workout ?? this.workout,
      workoutName: workoutName ?? this.workoutName,
      stages: stages != null ? [...stages] : this.stages,
    );
  }

  bool _isDateDifferentThanOriginal() =>
      !_dateService.areDatesTheSame(date!, workout!.date);

  bool _areStagesDifferentThanOriginal() {
    final originalStages = [...?workout?.stages];
    return !areListsEqual(stages, originalStages);
  }
}
