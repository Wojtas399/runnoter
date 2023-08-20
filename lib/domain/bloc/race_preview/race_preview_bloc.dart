import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
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
  final String _userId;
  final String? raceId;

  RacePreviewBloc({
    required String userId,
    required this.raceId,
    RacePreviewState state = const RacePreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _userId = userId,
        _authService = getIt<AuthService>(),
        _raceRepository = getIt<RaceRepository>(),
        super(state) {
    on<RacePreviewEventInitialize>(_initialize, transformer: restartable());
    on<RacePreviewEventDeleteRace>(_deleteRace);
  }

  Future<void> _initialize(
    RacePreviewEventInitialize event,
    Emitter<RacePreviewState> emit,
  ) async {
    if (raceId == null) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    final Stream<Race?> race$ = _raceRepository.getRaceById(
      raceId: raceId!,
      userId: _userId,
    );
    await emit.forEach(
      race$,
      onData: (Race? race) => state.copyWith(
        canEditRaceStatus: _userId == loggedUserId,
        race: race,
      ),
    );
  }

  Future<void> _deleteRace(
    RacePreviewEventDeleteRace event,
    Emitter<RacePreviewState> emit,
  ) async {
    final String? raceId = state.race?.id;
    if (raceId == null) return;
    emitLoadingStatus(emit);
    await _raceRepository.deleteRace(raceId: raceId, userId: _userId);
    emitCompleteStatus(emit, info: RacePreviewBlocInfo.raceDeleted);
  }
}

enum RacePreviewBlocInfo { raceDeleted }
