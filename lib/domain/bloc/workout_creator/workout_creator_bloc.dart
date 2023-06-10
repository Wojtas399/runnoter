import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/run_status.dart';
import '../../../../domain/entity/workout.dart';
import '../../../../domain/entity/workout_stage.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../service/list_service.dart';

part 'workout_creator_event.dart';
part 'workout_creator_state.dart';

class WorkoutCreatorBloc extends BlocWithStatus<WorkoutCreatorEvent,
    WorkoutCreatorState, WorkoutCreatorBlocInfo, dynamic> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  StreamSubscription<Workout?>? _workoutListener;

  WorkoutCreatorBloc({
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    BlocStatus status = const BlocStatusComplete(),
    DateTime? date,
    Workout? workout,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        super(
          WorkoutCreatorState(
            status: status,
            date: date,
            workout: workout,
            workoutName: workoutName,
            stages: stages,
          ),
        ) {
    on<WorkoutCreatorEventInitialize>(_initialize);
    on<WorkoutCreatorEventWorkoutNameChanged>(_workoutNameChanged);
    on<WorkoutCreatorEventWorkoutStageAdded>(_workoutStageAdded);
    on<WorkoutCreatorEventWorkoutStagesOrderChanged>(
      _workoutStagesOrderChanged,
    );
    on<WorkoutCreatorEventDeleteWorkoutStage>(_deleteWorkoutStage);
    on<WorkoutCreatorEventSubmit>(_submit);
  }

  @override
  Future<void> close() {
    _workoutListener?.cancel();
    _workoutListener = null;
    return super.close();
  }

  Future<void> _initialize(
    WorkoutCreatorEventInitialize event,
    Emitter<WorkoutCreatorState> emit,
  ) async {
    final String? workoutId = event.workoutId;
    if (workoutId != null) {
      final String? loggedUserId = await _authService.loggedUserId$.first;
      if (loggedUserId != null) {
        final Workout? workout = await _loadWorkoutById(
          workoutId,
          loggedUserId,
        );
        emit(state.copyWith(
          status: const BlocStatusComplete<WorkoutCreatorBlocInfo>(
            info: WorkoutCreatorBlocInfo.editModeInitialized,
          ),
          date: event.date,
          workout: workout,
          workoutName: workout?.name,
          stages: workout?.stages,
        ));
        return;
      }
    }
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
    final String? workoutName = state.workoutName;
    if (state.date == null ||
        workoutName == null ||
        workoutName.isEmpty ||
        state.stages.isEmpty) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    emitLoadingStatus(emit);
    if (state.workout != null) {
      await _updateWorkout(loggedUserId);
      emitCompleteStatus(emit, WorkoutCreatorBlocInfo.workoutUpdated);
    } else {
      await _addWorkout(loggedUserId);
      emitCompleteStatus(emit, WorkoutCreatorBlocInfo.workoutAdded);
    }
  }

  Future<Workout?> _loadWorkoutById(String workoutId, String userId) async {
    return await _workoutRepository
        .getWorkoutById(
          workoutId: workoutId,
          userId: userId,
        )
        .first;
  }

  Future<void> _addWorkout(String userId) async {
    await _workoutRepository.addWorkout(
      userId: userId,
      workoutName: state.workoutName!,
      date: state.date!,
      status: const RunStatusPending(),
      stages: state.stages,
    );
  }

  Future<void> _updateWorkout(String userId) async {
    await _workoutRepository.updateWorkout(
      workoutId: state.workout!.id,
      userId: userId,
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
