import 'package:flutter_bloc/flutter_bloc.dart';

import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../entity/competition.dart';
import '../../entity/run_status.dart';
import '../../repository/competition_repository.dart';
import '../../service/auth_service.dart';

part 'competition_creator_event.dart';
part 'competition_creator_state.dart';

class CompetitionCreatorBloc extends BlocWithStatus<CompetitionCreatorEvent,
    CompetitionCreatorState, CompetitionCreatorBlocInfo, dynamic> {
  final AuthService _authService;
  final CompetitionRepository _competitionRepository;

  CompetitionCreatorBloc({
    required AuthService authService,
    required CompetitionRepository competitionRepository,
    CompetitionCreatorState state = const CompetitionCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _competitionRepository = competitionRepository,
        super(state) {
    on<CompetitionCreatorEventInitialize>(_initialize);
    on<CompetitionCreatorEventNameChanged>(_nameChanged);
    on<CompetitionCreatorEventDateChanged>(_dateChanged);
    on<CompetitionCreatorEventPlaceChanged>(_placeChanged);
    on<CompetitionCreatorEventDistanceChanged>(_distanceChanged);
    on<CompetitionCreatorEventExpectedDurationChanged>(
      _expectedDurationChanged,
    );
    on<CompetitionCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    CompetitionCreatorEventInitialize event,
    Emitter<CompetitionCreatorState> emit,
  ) async {
    if (event.competitionId == null) {
      emitCompleteStatus(emit, null);
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    final Competition? competition = await _competitionRepository
        .getCompetitionById(
          competitionId: event.competitionId!,
          userId: loggedUserId,
        )
        .first;
    emit(state.copyWith(
      status: const BlocStatusComplete<CompetitionCreatorBlocInfo>(
        info: CompetitionCreatorBlocInfo.editModeInitialized,
      ),
      competition: competition,
      name: competition?.name,
      date: competition?.date,
      place: competition?.place,
      distance: competition?.distance,
      expectedDuration: competition?.expectedDuration,
    ));
  }

  void _nameChanged(
    CompetitionCreatorEventNameChanged event,
    Emitter<CompetitionCreatorState> emit,
  ) {
    emit(state.copyWith(
      name: event.name,
    ));
  }

  void _dateChanged(
    CompetitionCreatorEventDateChanged event,
    Emitter<CompetitionCreatorState> emit,
  ) {
    emit(state.copyWith(
      date: event.date,
    ));
  }

  void _placeChanged(
    CompetitionCreatorEventPlaceChanged event,
    Emitter<CompetitionCreatorState> emit,
  ) {
    emit(state.copyWith(
      place: event.place,
    ));
  }

  void _distanceChanged(
    CompetitionCreatorEventDistanceChanged event,
    Emitter<CompetitionCreatorState> emit,
  ) {
    emit(state.copyWith(
      distance: event.distance,
    ));
  }

  void _expectedDurationChanged(
    CompetitionCreatorEventExpectedDurationChanged event,
    Emitter<CompetitionCreatorState> emit,
  ) {
    emit(state.copyWith(
      expectedDuration: event.expectedDuration,
    ));
  }

  Future<void> _submit(
    CompetitionCreatorEventSubmit event,
    Emitter<CompetitionCreatorState> emit,
  ) async {
    if (!state.areDataValid || state.areDataSameAsOriginal) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    Duration? expectedDuration = state.expectedDuration;
    if (expectedDuration != null && expectedDuration.inSeconds == 0) {
      expectedDuration = null;
    }
    if (state.competition == null) {
      await _addNewCompetition(emit, loggedUserId, expectedDuration);
    } else {
      await _updateCompetition(emit, loggedUserId, expectedDuration);
    }
  }

  Future<void> _addNewCompetition(
    Emitter<CompetitionCreatorState> emit,
    String loggedUserId,
    Duration? expectedDuration,
  ) async {
    await _competitionRepository.addNewCompetition(
      userId: loggedUserId,
      name: state.name!,
      date: state.date!,
      place: state.place!,
      distance: state.distance!,
      expectedDuration: expectedDuration,
      status: const RunStatusPending(),
    );
    emitCompleteStatus(emit, CompetitionCreatorBlocInfo.competitionAdded);
  }

  Future<void> _updateCompetition(
    Emitter<CompetitionCreatorState> emit,
    String loggedUserId,
    Duration? expectedDuration,
  ) async {
    await _competitionRepository.updateCompetition(
      competitionId: state.competition!.id,
      userId: loggedUserId,
      name: state.name!,
      date: state.date!,
      place: state.place!,
      distance: state.distance!,
      expectedDuration: expectedDuration,
      setDurationAsNull: expectedDuration == null,
    );
    emitCompleteStatus(emit, CompetitionCreatorBlocInfo.competitionUpdated);
  }
}

enum CompetitionCreatorBlocInfo {
  editModeInitialized,
  competitionAdded,
  competitionUpdated,
}
