import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/run_status.dart';
import '../../../../domain/entity/workout.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';

part 'run_status_creator_event.dart';
part 'run_status_creator_state.dart';

class RunStatusCreatorBloc extends BlocWithStatus<RunStatusCreatorEvent,
    RunStatusCreatorState, RunStatusCreatorBlocInfo, dynamic> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;

  RunStatusCreatorBloc({
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    BlocStatus status = const BlocStatusInitial(),
    String? workoutId,
    RunStatusType? runStatusType,
    double? coveredDistanceInKm,
    MoodRate? moodRate,
    int? averagePaceMinutes,
    int? averagePaceSeconds,
    int? averageHeartRate,
    String? comment,
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        super(
          RunStatusCreatorState(
            status: status,
            workoutId: workoutId,
            runStatusType: runStatusType,
            coveredDistanceInKm: coveredDistanceInKm,
            moodRate: moodRate,
            averagePaceMinutes: averagePaceMinutes,
            averagePaceSeconds: averagePaceSeconds,
            averageHeartRate: averageHeartRate,
            comment: comment,
          ),
        ) {
    on<RunStatusCreatorEventInitialize>(_initialize);
    on<RunStatusCreatorEventRunStatusTypeChanged>(
      _runStatusTypeChanged,
    );
    on<RunStatusCreatorEventCoveredDistanceInKmChanged>(
      _coveredDistanceInKmChanged,
    );
    on<RunStatusCreatorEventMoodRateChanged>(_moodRateChanged);
    on<RunStatusCreatorEventAvgPaceMinutesChanged>(_avgPaceMinutesChanged);
    on<RunStatusCreatorEventAvgPaceSecondsChanged>(_avgPaceSecondsChanged);
    on<RunStatusCreatorEventAvgHeartRateChanged>(_avgHeartRateChanged);
    on<RunStatusCreatorEventCommentChanged>(_commentChanged);
    on<RunStatusCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    RunStatusCreatorEventInitialize event,
    Emitter<RunStatusCreatorState> emit,
  ) async {
    if (event.runStatusType != null) {
      emit(state.copyWith(
        workoutId: event.workoutId,
        runStatusType: event.runStatusType,
      ));
      return;
    }
    const BlocStatus blocStatus = BlocStatusComplete<RunStatusCreatorBlocInfo>(
      info: RunStatusCreatorBlocInfo.runStatusInitialized,
    );
    final Workout? workout = await _loadWorkoutById(event.workoutId, emit);
    final RunStatus? runStatus = workout?.status;
    if (runStatus is RunStats) {
      emit(state.copyWith(
        status: blocStatus,
        workoutId: event.workoutId,
        runStatus: runStatus,
        runStatusType: _getRunStatusType(runStatus),
        coveredDistanceInKm: runStatus.coveredDistanceInKm,
        moodRate: runStatus.moodRate,
        averagePaceMinutes: runStatus.avgPace.minutes,
        averagePaceSeconds: runStatus.avgPace.seconds,
        averageHeartRate: runStatus.avgHeartRate,
        comment: runStatus.comment,
      ));
    } else if (runStatus is RunStatusPending) {
      emit(state.copyWith(
        status: blocStatus,
        workoutId: event.workoutId,
        runStatus: runStatus,
        runStatusType: RunStatusType.pending,
      ));
    }
  }

  void _runStatusTypeChanged(
    RunStatusCreatorEventRunStatusTypeChanged event,
    Emitter<RunStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      runStatusType: event.runStatusType,
    ));
  }

  void _coveredDistanceInKmChanged(
    RunStatusCreatorEventCoveredDistanceInKmChanged event,
    Emitter<RunStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      coveredDistanceInKm: event.coveredDistanceInKm,
    ));
  }

  void _moodRateChanged(
    RunStatusCreatorEventMoodRateChanged event,
    Emitter<RunStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      moodRate: event.moodRate,
    ));
  }

  void _avgPaceMinutesChanged(
    RunStatusCreatorEventAvgPaceMinutesChanged event,
    Emitter<RunStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      averagePaceMinutes: event.minutes,
    ));
  }

  void _avgPaceSecondsChanged(
    RunStatusCreatorEventAvgPaceSecondsChanged event,
    Emitter<RunStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      averagePaceSeconds: event.seconds,
    ));
  }

  void _avgHeartRateChanged(
    RunStatusCreatorEventAvgHeartRateChanged event,
    Emitter<RunStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      averageHeartRate: event.averageHeartRate,
    ));
  }

  void _commentChanged(
    RunStatusCreatorEventCommentChanged event,
    Emitter<RunStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      comment: event.comment,
    ));
  }

  Future<void> _submit(
    RunStatusCreatorEventSubmit event,
    Emitter<RunStatusCreatorState> emit,
  ) async {
    if (state.workoutId == null) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    if (state.isFormValid && !state.areDataSameAsOriginal) {
      emitLoadingStatus(emit);
      final RunStatus newStatus = _createStatus();
      await _workoutRepository.updateWorkout(
        workoutId: state.workoutId!,
        userId: loggedUserId,
        status: newStatus,
      );
      emitCompleteStatus(emit, RunStatusCreatorBlocInfo.runStatusSaved);
    }
  }

  Future<Workout?> _loadWorkoutById(
    String workoutId,
    Emitter<RunStatusCreatorState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return null;
    }
    return await _workoutRepository
        .getWorkoutById(
          workoutId: workoutId,
          userId: loggedUserId,
        )
        .first;
  }

  RunStatusType _getRunStatusType(RunStatus runStatus) {
    if (runStatus is RunStatusPending) {
      return RunStatusType.pending;
    } else if (runStatus is RunStatusDone) {
      return RunStatusType.done;
    } else if (runStatus is RunStatusAborted) {
      return RunStatusType.aborted;
    } else if (runStatus is RunStatusUndone) {
      return RunStatusType.undone;
    } else {
      throw '[RunStatusCreatorBloc]: Unknown workout status';
    }
  }

  RunStatus _createStatus() {
    switch (state.runStatusType!) {
      case RunStatusType.pending:
        return const RunStatusPending();
      case RunStatusType.done:
        return RunStatusDone(
          coveredDistanceInKm: state.coveredDistanceInKm!,
          avgPace: Pace(
            minutes: state.averagePaceMinutes!,
            seconds: state.averagePaceSeconds!,
          ),
          avgHeartRate: state.averageHeartRate!,
          moodRate: state.moodRate!,
          comment: state.comment,
        );
      case RunStatusType.aborted:
        return RunStatusAborted(
          coveredDistanceInKm: state.coveredDistanceInKm!,
          avgPace: Pace(
            minutes: state.averagePaceMinutes!,
            seconds: state.averagePaceSeconds!,
          ),
          avgHeartRate: state.averageHeartRate!,
          moodRate: state.moodRate!,
          comment: state.comment,
        );
      case RunStatusType.undone:
        return const RunStatusUndone();
    }
  }
}

enum RunStatusCreatorBlocInfo {
  runStatusInitialized,
  runStatusSaved,
}
