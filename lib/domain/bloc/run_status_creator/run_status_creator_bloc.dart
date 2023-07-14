import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/run_status.dart';
import '../../repository/race_repository.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

part 'run_status_creator_event.dart';
part 'run_status_creator_state.dart';

enum RunStatusCreatorEntityType {
  workout,
  race,
}

class RunStatusCreatorBloc extends BlocWithStatus<RunStatusCreatorEvent,
    RunStatusCreatorState, RunStatusCreatorBlocInfo, dynamic> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final RunStatusCreatorEntityType? entityType;
  final String? entityId;

  RunStatusCreatorBloc({
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    required RaceRepository raceRepository,
    required this.entityType,
    required this.entityId,
    RunStatusCreatorState state = const RunStatusCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        _raceRepository = raceRepository,
        super(state) {
    on<RunStatusCreatorEventInitialize>(_initialize);
    on<RunStatusCreatorEventRunStatusTypeChanged>(_runStatusTypeChanged);
    on<RunStatusCreatorEventCoveredDistanceInKmChanged>(
      _coveredDistanceInKmChanged,
    );
    on<RunStatusCreatorEventDurationChanged>(_durationChanged);
    on<RunStatusCreatorEventMoodRateChanged>(_moodRateChanged);
    on<RunStatusCreatorEventAvgPaceChanged>(_avgPaceChanged);
    on<RunStatusCreatorEventAvgHeartRateChanged>(_avgHeartRateChanged);
    on<RunStatusCreatorEventCommentChanged>(_commentChanged);
    on<RunStatusCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    RunStatusCreatorEventInitialize event,
    Emitter<RunStatusCreatorState> emit,
  ) async {
    if (entityType == null || entityId == null) return;
    final Stream<RunStatus?> runStatus$ = _getRunStatus();
    await for (final runStatus in runStatus$) {
      if (runStatus == null) return;
      RunStatusCreatorState updatedState = state.copyWith(
        originalRunStatus: runStatus,
        runStatusType: _getRunStatusType(runStatus),
      );
      if (runStatus is RunStatusWithParams) {
        updatedState = updatedState.copyWith(
          coveredDistanceInKm: runStatus.coveredDistanceInKm,
          duration: runStatus.duration,
          moodRate: runStatus.moodRate,
          avgPace: runStatus.avgPace,
          avgHeartRate: runStatus.avgHeartRate,
          comment: runStatus.comment,
        );
      }
      emit(updatedState);
      return;
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

  void _durationChanged(
    RunStatusCreatorEventDurationChanged event,
    Emitter<RunStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      duration: event.duration,
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

  void _avgPaceChanged(
    RunStatusCreatorEventAvgPaceChanged event,
    Emitter<RunStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      avgPace: event.avgPace,
    ));
  }

  void _avgHeartRateChanged(
    RunStatusCreatorEventAvgHeartRateChanged event,
    Emitter<RunStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      avgHeartRate: event.averageHeartRate,
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
    if (!state.canSubmit || entityType == null || entityId == null) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    final RunStatus status = _createStatus();
    emitLoadingStatus(emit);
    await switch (entityType!) {
      RunStatusCreatorEntityType.workout => _workoutRepository.updateWorkout(
          workoutId: entityId!,
          userId: loggedUserId,
          status: status,
        ),
      RunStatusCreatorEntityType.race => _raceRepository.updateRace(
          raceId: entityId!,
          userId: loggedUserId,
          status: status,
        ),
    };
    emitCompleteStatus(emit, RunStatusCreatorBlocInfo.runStatusSaved);
  }

  Stream<RunStatus?> _getRunStatus() =>
      _authService.loggedUserId$.whereType<String>().switchMap(
            (String loggedUserId) => switch (entityType!) {
              RunStatusCreatorEntityType.workout =>
                _getWorkoutRunStatus(loggedUserId),
              RunStatusCreatorEntityType.race =>
                _getRaceRunStatus(loggedUserId),
            },
          );

  Stream<RunStatus?> _getWorkoutRunStatus(String loggedUserId) =>
      _workoutRepository
          .getWorkoutById(workoutId: entityId!, userId: loggedUserId)
          .map((workout) => workout?.status);

  Stream<RunStatus?> _getRaceRunStatus(String loggedUserId) => _raceRepository
      .getRaceById(raceId: entityId!, userId: loggedUserId)
      .map((race) => race?.status);

  RunStatusType _getRunStatusType(RunStatus runStatus) => switch (runStatus) {
        RunStatusPending() => RunStatusType.done,
        RunStatusDone() => RunStatusType.done,
        RunStatusAborted() => RunStatusType.aborted,
        RunStatusUndone() => RunStatusType.undone,
      };

  RunStatus _createStatus() => switch (state.runStatusType!) {
        RunStatusType.pending => const RunStatusPending(),
        RunStatusType.done => RunStatusDone(
            coveredDistanceInKm: state.coveredDistanceInKm!,
            duration: state.duration,
            avgPace: state.avgPace!,
            avgHeartRate: state.avgHeartRate!,
            moodRate: state.moodRate!,
            comment: state.comment,
          ),
        RunStatusType.aborted => RunStatusAborted(
            coveredDistanceInKm: state.coveredDistanceInKm!,
            duration: state.duration,
            avgPace: state.avgPace!,
            avgHeartRate: state.avgHeartRate!,
            moodRate: state.moodRate!,
            comment: state.comment,
          ),
        RunStatusType.undone => const RunStatusUndone(),
      };
}

enum RunStatusCreatorBlocInfo {
  runStatusSaved,
}
