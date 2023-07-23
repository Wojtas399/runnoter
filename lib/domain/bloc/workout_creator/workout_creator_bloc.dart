import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/run_status.dart';
import '../../../../domain/entity/workout.dart';
import '../../../../domain/entity/workout_stage.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../service/list_service.dart';

part 'workout_creator_event.dart';
part 'workout_creator_state.dart';

class WorkoutCreatorBloc extends BlocWithStatus<WorkoutCreatorEvent,
    WorkoutCreatorState, WorkoutCreatorBlocInfo, dynamic> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final DateTime? date;
  final String? workoutId;

  WorkoutCreatorBloc({
    this.date,
    this.workoutId,
    WorkoutCreatorState state = const WorkoutCreatorState(
      status: BlocStatusInitial(),
      stages: [],
    ),
  })  : _authService = getIt<AuthService>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        super(state) {
    on<WorkoutCreatorEventInitialize>(_initialize);
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
    final Stream<Workout?> workout$ = _getWorkoutById(workoutId!);
    await for (final workout in workout$) {
      emit(state.copyWith(
        status: const BlocStatusComplete<WorkoutCreatorBlocInfo>(
          info: WorkoutCreatorBlocInfo.editModeInitialized,
        ),
        workout: workout,
        workoutName: workout?.name,
        stages: [...?workout?.stages],
      ));
      return;
    }
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
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    if (state.workout != null) {
      await _updateWorkout(loggedUserId);
      emitCompleteStatus(emit, WorkoutCreatorBlocInfo.workoutUpdated);
    } else if (date != null) {
      await _addWorkout(loggedUserId);
      emitCompleteStatus(emit, WorkoutCreatorBlocInfo.workoutAdded);
    }
  }

  Stream<Workout?> _getWorkoutById(String workoutId) =>
      _authService.loggedUserId$.whereNotNull().switchMap(
            (String loggedUserId) => _workoutRepository.getWorkoutById(
              workoutId: workoutId,
              userId: loggedUserId,
            ),
          );

  Future<void> _addWorkout(String userId) async {
    await _workoutRepository.addWorkout(
      userId: userId,
      workoutName: state.workoutName!,
      date: date!,
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
