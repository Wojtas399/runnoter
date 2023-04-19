import '../../../model/bloc_status.dart';
import 'workout_stage_creator_state.dart';

class WorkoutStageCreatorEmptyState extends WorkoutStageCreatorState {
  const WorkoutStageCreatorEmptyState({
    required super.status,
  });

  @override
  bool get areDataCorrect => true;

  @override
  WorkoutStageCreatorEmptyState copyWith({
    BlocStatus? status,
  }) =>
      WorkoutStageCreatorEmptyState(
        status: status ?? const BlocStatusComplete(),
      );

  @override
  List<Object?> get props => [];
}
