import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/run_status.dart';
import '../../repository/competition_repository.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

part 'run_status_creator_event.dart';
part 'run_status_creator_state.dart';

enum EntityType {
  workout,
  competition,
}

class RunStatusCreatorBloc extends BlocWithStatus<RunStatusCreatorEvent,
    RunStatusCreatorState, RunStatusCreatorBlocInfo, dynamic> {
  final EntityType _entityType;
  final String _entityId;
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final CompetitionRepository _competitionRepository;

  RunStatusCreatorBloc({
    required EntityType entityType,
    required String entityId,
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    required CompetitionRepository competitionRepository,
    RunStatusCreatorState state = const RunStatusCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _entityType = entityType,
        _entityId = entityId,
        _authService = authService,
        _workoutRepository = workoutRepository,
        _competitionRepository = competitionRepository,
        super(state) {
    on<RunStatusCreatorEventInitialize>(_initialize);
    on<RunStatusCreatorEventRunStatusTypeChanged>(_runStatusTypeChanged);
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
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    final RunStatus? runStatus = await _loadRunStatus(loggedUserId);
    if (runStatus == null) {
      return;
    }
    RunStatusCreatorState updatedState = state.copyWith(
      originalRunStatus: runStatus,
      runStatusType: runStatus is RunStatusPending
          ? RunStatusType.done
          : _getRunStatusType(runStatus),
    );
    if (runStatus is RunStatusWithParams) {
      updatedState = updatedState.copyWith(
        coveredDistanceInKm: runStatus.coveredDistanceInKm,
        moodRate: runStatus.moodRate,
        averagePaceMinutes: runStatus.avgPace.minutes,
        averagePaceSeconds: runStatus.avgPace.seconds,
        averageHeartRate: runStatus.avgHeartRate,
        comment: runStatus.comment,
      );
    }
    emit(updatedState.copyWith(
      status: const BlocStatusComplete<RunStatusCreatorBlocInfo>(
        info: RunStatusCreatorBlocInfo.runStatusInitialized,
      ),
    ));
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
    if (!state.isFormValid || state.areDataSameAsOriginal) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    final RunStatus status = _createStatus();
    emitLoadingStatus(emit);
    await switch (_entityType) {
      EntityType.workout => _workoutRepository.updateWorkout(
          workoutId: _entityId,
          userId: loggedUserId,
          status: status,
        ),
      EntityType.competition => _competitionRepository.updateCompetition(
          competitionId: _entityId,
          userId: loggedUserId,
          status: status,
        ),
    };
    emitCompleteStatus(emit, RunStatusCreatorBlocInfo.runStatusSaved);
  }

  Future<RunStatus?> _loadRunStatus(
    String loggedUserId,
  ) async =>
      switch (_entityType) {
        EntityType.workout => (await _workoutRepository
                .getWorkoutById(
                  workoutId: _entityId,
                  userId: loggedUserId,
                )
                .first)
            ?.status,
        EntityType.competition => (await _competitionRepository
                .getCompetitionById(
                  competitionId: _entityId,
                  userId: loggedUserId,
                )
                .first)
            ?.status,
      };

  RunStatusType _getRunStatusType(RunStatus runStatus) => switch (runStatus) {
        RunStatusPending() => RunStatusType.pending,
        RunStatusDone() => RunStatusType.done,
        RunStatusAborted() => RunStatusType.aborted,
        RunStatusUndone() => RunStatusType.undone,
      };

  RunStatus _createStatus() => switch (state.runStatusType!) {
        RunStatusType.pending => const RunStatusPending(),
        RunStatusType.done => RunStatusDone(
            coveredDistanceInKm: state.coveredDistanceInKm!,
            avgPace: Pace(
              minutes: state.averagePaceMinutes!,
              seconds: state.averagePaceSeconds!,
            ),
            avgHeartRate: state.averageHeartRate!,
            moodRate: state.moodRate!,
            comment: state.comment,
          ),
        RunStatusType.aborted => RunStatusAborted(
            coveredDistanceInKm: state.coveredDistanceInKm!,
            avgPace: Pace(
              minutes: state.averagePaceMinutes!,
              seconds: state.averagePaceSeconds!,
            ),
            avgHeartRate: state.averageHeartRate!,
            moodRate: state.moodRate!,
            comment: state.comment,
          ),
        RunStatusType.undone => const RunStatusUndone(),
      };
}

enum RunStatusCreatorBlocInfo {
  runStatusInitialized,
  runStatusSaved,
}
