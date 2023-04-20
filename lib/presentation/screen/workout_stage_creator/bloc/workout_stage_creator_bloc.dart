import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'workout_stage_creator_distance_stage_state.dart';
import 'workout_stage_creator_empty_state.dart';
import 'workout_stage_creator_event.dart';
import 'workout_stage_creator_series_stage_state.dart';
import 'workout_stage_creator_state.dart';

class WorkoutStageCreatorBloc extends BlocWithStatus<WorkoutStageCreatorEvent,
    WorkoutStageCreatorState, dynamic, dynamic> {
  WorkoutStageCreatorBloc({
    BlocStatus status = const BlocStatusInitial(),
  }) : super(
          WorkoutStageCreatorEmptyState(
            status: status,
          ),
        ) {
    on<WorkoutStageCreatorEventStageTypeChanged>(_stageTypeChanged);
  }

  void _stageTypeChanged(
    WorkoutStageCreatorEventStageTypeChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStage stage = event.stage;
    if (_isDistanceStage(stage)) {
      emit(
        const WorkoutStageCreatorDistanceStageState(
          status: BlocStatusComplete(),
          distanceInKm: null,
          maxHeartRate: null,
        ),
      );
    } else if (_isSeriesStage(stage)) {
      emit(
        const WorkoutStageCreatorSeriesStageState(
          status: BlocStatusComplete(),
          amountOfSeries: null,
          seriesDistanceInMeters: null,
          breakWalkingDistanceInMeters: null,
          breakJoggingDistanceInMeters: null,
        ),
      );
    } else {
      emit(
        const WorkoutStageCreatorEmptyState(
          status: BlocStatusComplete(),
        ),
      );
    }
  }

  bool _isDistanceStage(WorkoutStage stage) {
    return stage == WorkoutStage.cardio ||
        stage == WorkoutStage.zone2 ||
        stage == WorkoutStage.zone3;
  }

  bool _isSeriesStage(WorkoutStage stage) {
    return stage == WorkoutStage.strength || stage == WorkoutStage.rhythms;
  }
}
