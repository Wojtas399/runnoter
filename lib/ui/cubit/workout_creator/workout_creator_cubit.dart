import 'dart:async';

import '../../../../../../domain/additional_model/cubit_status.dart';
import '../../../../../common/date_service.dart';
import '../../../../../data/additional_model/activity_status.dart';
import '../../../../../data/additional_model/custom_exception.dart';
import '../../../../../data/additional_model/workout_stage.dart';
import '../../../../../data/entity/workout.dart';
import '../../../../../data/interface/repository/workout_repository.dart';
import '../../../../../dependency_injection.dart';
import '../../../../../domain/additional_model/cubit_state.dart';
import '../../../../../domain/additional_model/cubit_with_status.dart';
import '../../../../../domain/service/list_service.dart';

part 'workout_creator_state.dart';

class WorkoutCreatorCubit extends CubitWithStatus<WorkoutCreatorState,
    WorkoutCreatorCubitInfo, WorkoutCreatorCubitError> {
  final WorkoutRepository _workoutRepository;
  final String userId;
  final String? workoutId;

  WorkoutCreatorCubit({
    required this.userId,
    this.workoutId,
    CubitStatus status = const CubitStatusInitial(),
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
        );

  Future<void> initialize() async {
    if (workoutId == null) {
      emitCompleteStatus();
      return;
    }
    final Stream<Workout?> workout$ = _workoutRepository.getWorkoutById(
      workoutId: workoutId!,
      userId: userId,
    );
    await for (final workout in workout$) {
      emit(state.copyWith(
        date: workout?.date,
        workout: workout,
        workoutName: workout?.name,
        stages: [...?workout?.stages],
      ));
      return;
    }
  }

  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }

  void workoutNameChanged(String workoutName) {
    emit(state.copyWith(workoutName: workoutName));
  }

  void workoutStageAdded(WorkoutStage stage) {
    emit(state.copyWith(stages: [...state.stages, stage]));
  }

  void updateWorkoutStageAtIndex({
    required int stageIndex,
    required WorkoutStage updatedStage,
  }) {
    if (state.stages.isEmpty || state.stages.length <= stageIndex) return;
    final List<WorkoutStage> updatedStages = [...state.stages];
    updatedStages[stageIndex] = updatedStage;
    emit(state.copyWith(stages: updatedStages));
  }

  void workoutStagesOrderChanged(List<WorkoutStage> stages) {
    emit(state.copyWith(stages: stages));
  }

  void deleteWorkoutStageAtIndex(int stageIndex) {
    final List<WorkoutStage> updatedStages = [...state.stages];
    updatedStages.removeAt(stageIndex);
    emit(state.copyWith(stages: updatedStages));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emitLoadingStatus();
    if (state.workout != null) {
      try {
        await _updateWorkout();
        emitCompleteStatus(info: WorkoutCreatorCubitInfo.workoutUpdated);
      } on EntityException catch (entityException) {
        if (entityException.code == EntityExceptionCode.entityNotFound) {
          emitErrorStatus(WorkoutCreatorCubitError.workoutNoLongerExists);
        }
      }
    } else if (state.date != null) {
      await _addWorkout();
      emitCompleteStatus(info: WorkoutCreatorCubitInfo.workoutAdded);
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

enum WorkoutCreatorCubitInfo { workoutAdded, workoutUpdated }

enum WorkoutCreatorCubitError { workoutNoLongerExists }
