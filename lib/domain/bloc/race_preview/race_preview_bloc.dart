import 'dart:async';

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
  StreamSubscription<Race?>? _raceListener;

  RacePreviewBloc({
    required AuthService authService,
    required RaceRepository raceRepository,
    RacePreviewState state = const RacePreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _raceRepository = raceRepository,
        super(state) {
    on<RacePreviewEventInitialize>(_initialize);
    on<RacePreviewEventRaceUpdated>(_raceUpdated);
    on<RacePreviewEventDeleteRace>(_deleteRace);
  }

  @override
  Future<void> close() {
    _raceListener?.cancel();
    _raceListener = null;
    return super.close();
  }

  void _initialize(
    RacePreviewEventInitialize event,
    Emitter<RacePreviewState> emit,
  ) {
    _raceListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _raceRepository.getRaceById(
            raceId: event.raceId,
            userId: loggedUserId,
          ),
        )
        .listen(
          (Race? race) => add(
            RacePreviewEventRaceUpdated(
              race: race,
            ),
          ),
        );
  }

  void _raceUpdated(
    RacePreviewEventRaceUpdated event,
    Emitter<RacePreviewState> emit,
  ) {
    emit(state.copyWith(
      race: event.race,
    ));
  }

  Future<void> _deleteRace(
    RacePreviewEventDeleteRace event,
    Emitter<RacePreviewState> emit,
  ) async {
    final String? raceId = state.race?.id;
    if (raceId == null) {
      return;
    }
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
