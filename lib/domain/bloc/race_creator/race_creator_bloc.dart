import 'package:flutter_bloc/flutter_bloc.dart';

import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../entity/race.dart';
import '../../entity/run_status.dart';
import '../../repository/race_repository.dart';
import '../../service/auth_service.dart';

part 'race_creator_event.dart';
part 'race_creator_state.dart';

class RaceCreatorBloc extends BlocWithStatus<RaceCreatorEvent, RaceCreatorState,
    RaceCreatorBlocInfo, dynamic> {
  final AuthService _authService;
  final RaceRepository _raceRepository;

  RaceCreatorBloc({
    required AuthService authService,
    required RaceRepository raceRepository,
    RaceCreatorState state = const RaceCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _raceRepository = raceRepository,
        super(state) {
    on<RaceCreatorEventInitialize>(_initialize);
    on<RaceCreatorEventNameChanged>(_nameChanged);
    on<RaceCreatorEventDateChanged>(_dateChanged);
    on<RaceCreatorEventPlaceChanged>(_placeChanged);
    on<RaceCreatorEventDistanceChanged>(_distanceChanged);
    on<RaceCreatorEventExpectedDurationChanged>(
      _expectedDurationChanged,
    );
    on<RaceCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    RaceCreatorEventInitialize event,
    Emitter<RaceCreatorState> emit,
  ) async {
    if (event.raceId == null) {
      emitCompleteStatus(emit, null);
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    final Race? race = await _raceRepository
        .getRaceById(
          raceId: event.raceId!,
          userId: loggedUserId,
        )
        .first;
    emit(state.copyWith(
      status: const BlocStatusComplete<RaceCreatorBlocInfo>(
        info: RaceCreatorBlocInfo.editModeInitialized,
      ),
      race: race,
      name: race?.name,
      date: race?.date,
      place: race?.place,
      distance: race?.distance,
      expectedDuration: race?.expectedDuration,
    ));
  }

  void _nameChanged(
    RaceCreatorEventNameChanged event,
    Emitter<RaceCreatorState> emit,
  ) {
    emit(state.copyWith(
      name: event.name,
    ));
  }

  void _dateChanged(
    RaceCreatorEventDateChanged event,
    Emitter<RaceCreatorState> emit,
  ) {
    emit(state.copyWith(
      date: event.date,
    ));
  }

  void _placeChanged(
    RaceCreatorEventPlaceChanged event,
    Emitter<RaceCreatorState> emit,
  ) {
    emit(state.copyWith(
      place: event.place,
    ));
  }

  void _distanceChanged(
    RaceCreatorEventDistanceChanged event,
    Emitter<RaceCreatorState> emit,
  ) {
    emit(state.copyWith(
      distance: event.distance,
    ));
  }

  void _expectedDurationChanged(
    RaceCreatorEventExpectedDurationChanged event,
    Emitter<RaceCreatorState> emit,
  ) {
    emit(state.copyWith(
      expectedDuration: event.expectedDuration,
    ));
  }

  Future<void> _submit(
    RaceCreatorEventSubmit event,
    Emitter<RaceCreatorState> emit,
  ) async {
    if (!state.canSubmit) {
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
    if (state.race == null) {
      await _addNewRace(emit, loggedUserId, expectedDuration);
    } else {
      await _updateRace(emit, loggedUserId, expectedDuration);
    }
  }

  Future<void> _addNewRace(
    Emitter<RaceCreatorState> emit,
    String loggedUserId,
    Duration? expectedDuration,
  ) async {
    await _raceRepository.addNewRace(
      userId: loggedUserId,
      name: state.name!,
      date: state.date!,
      place: state.place!,
      distance: state.distance!,
      expectedDuration: expectedDuration,
      status: const RunStatusPending(),
    );
    emitCompleteStatus(emit, RaceCreatorBlocInfo.raceAdded);
  }

  Future<void> _updateRace(
    Emitter<RaceCreatorState> emit,
    String loggedUserId,
    Duration? expectedDuration,
  ) async {
    await _raceRepository.updateRace(
      raceId: state.race!.id,
      userId: loggedUserId,
      name: state.name!,
      date: state.date!,
      place: state.place!,
      distance: state.distance!,
      expectedDuration: expectedDuration,
      setDurationAsNull: expectedDuration == null,
    );
    emitCompleteStatus(emit, RaceCreatorBlocInfo.raceUpdated);
  }
}

enum RaceCreatorBlocInfo {
  editModeInitialized,
  raceAdded,
  raceUpdated,
}
