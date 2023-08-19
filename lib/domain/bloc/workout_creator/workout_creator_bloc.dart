import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/workout.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/activity_status.dart';
import '../../additional_model/workout_stage.dart';
import '../../service/list_service.dart';

part 'workout_creator_event.dart';
part 'workout_creator_state.dart';

class WorkoutCreatorBloc extends BlocWithStatus<WorkoutCreatorEvent,
    WorkoutCreatorState, WorkoutCreatorBlocInfo, dynamic> {
  final WorkoutRepository _workoutRepository;
  final String userId;
  final String? workoutId;

  WorkoutCreatorBloc({
    required this.userId,
    this.workoutId,
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    Workout? workout,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  })  : _workoutRepository = getIt<WorkoutRepository>(),
        super(
          WorkoutCreatorState(
            dateService: getIt<DateService>(),
            status: status,
            date: date,
            workout: workout,
            workoutName: workoutName,
            stages: stages,
          ),
        ) {
    on<WorkoutCreatorEventInitialize>(_initialize);
    on<WorkoutCreatorEventDateChanged>(_dateChanged);
    on<WorkoutCreatorEventWorkoutNameChanged>(_workoutNameChanged);
    on<WorkoutCreatorEventWorkoutStageAdded>(_workoutStageAdded);
    on<WorkoutCreatorEventWorkoutStageUpdated>(_workoutStageUpdated);
    on<WorkoutCreatorEventWorkoutStagesOrderChanged>(
      _workoutStagesOrderChanged,
    );
    on<WorkoutCreatorEventDeleteWorkoutStage>(_deleteWorkoutStage);
    on<WorkoutCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    WorkoutCreatorEventInitialize event,
    Emitter<WorkoutCreatorState> emit,
  ) async {
    if (workoutId == null) {
      emit(state.copyWith(
        status: const BlocStatusComplete(),
      ));
      return;
    }
    final Stream<Workout?> workout$ = _workoutRepository.getWorkoutById(
      workoutId: workoutId!,
      userId: userId,
    );
    await for (final workout in workout$) {
      emit(state.copyWith(
        status: const BlocStatusComplete<WorkoutCreatorBlocInfo>(
          info: WorkoutCreatorBlocInfo.editModeInitialized,
        ),
        date: workout?.date,
        workout: workout,
        workoutName: workout?.name,
        stages: [...?workout?.stages],
      ));
      return;
    }
  }

  void _dateChanged(
    WorkoutCreatorEventDateChanged event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    emit(state.copyWith(
      date: event.date,
    ));
  }

  void _workoutNameChanged(
    WorkoutCreatorEventWorkoutNameChanged event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    emit(state.copyWith(
      workoutName: event.workoutName,
    ));
  }

  void _workoutStageAdded(
    WorkoutCreatorEventWorkoutStageAdded event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    emit(state.copyWith(
      stages: [
        ...state.stages,
        event.workoutStage,
      ],
    ));
  }

  void _workoutStageUpdated(
    WorkoutCreatorEventWorkoutStageUpdated event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    if (state.stages.isEmpty || state.stages.length <= event.stageIndex) {
      return;
    }
    final List<WorkoutStage> updatedStages = [...state.stages];
    updatedStages[event.stageIndex] = event.workoutStage;
    emit(state.copyWith(
      stages: updatedStages,
    ));
  }

  void _workoutStagesOrderChanged(
    WorkoutCreatorEventWorkoutStagesOrderChanged event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    emit(state.copyWith(
      stages: event.workoutStages,
    ));
  }

  void _deleteWorkoutStage(
    WorkoutCreatorEventDeleteWorkoutStage event,
    Emitter<WorkoutCreatorState> emit,
  ) {
    final List<WorkoutStage> updatedStages = [
      ...state.stages,
    ];
    updatedStages.removeAt(event.index);
    emit(state.copyWith(
      stages: updatedStages,
    ));
  }

  Future<void> _submit(
    WorkoutCreatorEventSubmit event,
    Emitter<WorkoutCreatorState> emit,
  ) async {
    if (!state.canSubmit) return;
    emitLoadingStatus(emit);
    if (state.workout != null) {
      await _updateWorkout();
      emitCompleteStatus(emit, info: WorkoutCreatorBlocInfo.workoutUpdated);
    } else if (state.date != null) {
      await _addWorkout();
      emitCompleteStatus(emit, info: WorkoutCreatorBlocInfo.workoutAdded);
    }
  }

  Future<void> _addWorkout() async {
    await _workoutRepository.addWorkout(
      userId: userId,
      workoutName: state.workoutName!,
      date: state.date!,
      status: const ActivityStatusPending(),
      stages: state.stages,
    );
  }

  Future<void> _updateWorkout() async {
    await _workoutRepository.updateWorkout(
      workoutId: state.workout!.id,
      userId: userId,
      date: state.date,
      workoutName: state.workoutName,
      stages: state.stages,
    );
  }
}

enum WorkoutCreatorBlocInfo {
  editModeInitialized,
  workoutAdded,
  workoutUpdated,
}
