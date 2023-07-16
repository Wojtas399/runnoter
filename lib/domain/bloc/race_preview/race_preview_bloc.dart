import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../entity/race.dart';
import '../../repository/race_repository.dart';
import '../../service/auth_service.dart';

part 'race_preview_event.dart';
part 'race_preview_state.dart';

class RacePreviewBloc extends BlocWithStatus<RacePreviewEvent, RacePreviewState,
    RacePreviewBlocInfo, dynamic> {
  final AuthService _authService;
  final RaceRepository _raceRepository;
  final String? raceId;

  RacePreviewBloc({
    required AuthService authService,
    required RaceRepository raceRepository,
    required this.raceId,
    RacePreviewState state = const RacePreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _raceRepository = raceRepository,
        super(state) {
    on<RacePreviewEventInitialize>(_initialize, transformer: restartable());
    on<RacePreviewEventDeleteRace>(_deleteRace);
  }

  Future<void> _initialize(
    RacePreviewEventInitialize event,
    Emitter<RacePreviewState> emit,
  ) async {
    if (raceId == null) return;
    final Stream<Race?> race$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => _raceRepository.getRaceById(
                raceId: raceId!,
                userId: loggedUserId,
              ),
            );
    await emit.forEach(
      race$,
      onData: (Race? race) => state.copyWith(race: race),
    );
  }

  Future<void> _deleteRace(
    RacePreviewEventDeleteRace event,
    Emitter<RacePreviewState> emit,
  ) async {
    final String? raceId = state.race?.id;
    if (raceId == null) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _raceRepository.deleteRace(
      raceId: raceId,
      userId: loggedUserId,
    );
    emitCompleteStatus(
      emit,
      RacePreviewBlocInfo.raceDeleted,
    );
  }
}

enum RacePreviewBlocInfo {
  raceDeleted,
}
