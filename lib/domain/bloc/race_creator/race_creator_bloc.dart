import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/activity_status.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../entity/race.dart';
import '../../repository/race_repository.dart';

part 'race_creator_event.dart';
part 'race_creator_state.dart';

class RaceCreatorBloc extends BlocWithStatus<RaceCreatorEvent, RaceCreatorState,
    RaceCreatorBlocInfo, dynamic> {
  final String _userId;
  final String? raceId;
  final RaceRepository _raceRepository;

  RaceCreatorBloc({
    required String userId,
    this.raceId,
    RaceCreatorState state = const RaceCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _userId = userId,
        _raceRepository = getIt<RaceRepository>(),
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
    if (raceId == null) {
      emit(state.copyWith(
        date: event.date,
      ));
      return;
    }
    final Stream<Race?> race$ = _raceRepository.getRaceById(
      raceId: raceId!,
      userId: _userId,
    );
    await for (final race in race$) {
      emit(state.copyWith(
        status: const BlocStatusComplete<RaceCreatorBlocInfo>(),
        race: race,
        name: race?.name,
        date: race?.date,
        place: race?.place,
        distance: race?.distance,
        expectedDuration: race?.expectedDuration,
      ));
      return;
    }
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
    emitLoadingStatus(emit);
    Duration? expectedDuration = state.expectedDuration;
    if (expectedDuration != null && expectedDuration.inSeconds == 0) {
      expectedDuration = null;
    }
    if (state.race == null) {
      await _addNewRace(emit, expectedDuration);
    } else {
      await _updateRace(emit, expectedDuration);
    }
  }

  Future<void> _addNewRace(
    Emitter<RaceCreatorState> emit,
    Duration? expectedDuration,
  ) async {
    await _raceRepository.addNewRace(
      userId: _userId,
      name: state.name!,
      date: state.date!,
      place: state.place!,
      distance: state.distance!,
      expectedDuration: expectedDuration,
      status: const ActivityStatusPending(),
    );
    emitCompleteStatus(emit, info: RaceCreatorBlocInfo.raceAdded);
  }

  Future<void> _updateRace(
    Emitter<RaceCreatorState> emit,
    Duration? expectedDuration,
  ) async {
    await _raceRepository.updateRace(
      raceId: state.race!.id,
      userId: _userId,
      name: state.name!,
      date: state.date!,
      place: state.place!,
      distance: state.distance!,
      expectedDuration: expectedDuration,
      setDurationAsNull: expectedDuration == null,
    );
    emitCompleteStatus(emit, info: RaceCreatorBlocInfo.raceUpdated);
  }
}

enum RaceCreatorBlocInfo {
  raceAdded,
  raceUpdated,
}
