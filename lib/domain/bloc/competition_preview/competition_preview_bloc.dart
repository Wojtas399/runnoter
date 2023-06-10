import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../entity/competition.dart';
import '../../repository/competition_repository.dart';
import '../../service/auth_service.dart';

part 'competition_preview_event.dart';
part 'competition_preview_state.dart';

class CompetitionPreviewBloc extends BlocWithStatus<CompetitionPreviewEvent,
    CompetitionPreviewState, CompetitionPreviewBlocInfo, dynamic> {
  final AuthService _authService;
  final CompetitionRepository _competitionRepository;
  StreamSubscription<Competition?>? _competitionListener;

  CompetitionPreviewBloc({
    required AuthService authService,
    required CompetitionRepository competitionRepository,
    CompetitionPreviewState state = const CompetitionPreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _competitionRepository = competitionRepository,
        super(state) {
    on<CompetitionPreviewEventInitialize>(_initialize);
    on<CompetitionPreviewEventCompetitionUpdated>(_competitionUpdated);
    on<CompetitionPreviewEventDeleteCompetition>(_deleteCompetition);
  }

  @override
  Future<void> close() {
    _competitionListener?.cancel();
    _competitionListener = null;
    return super.close();
  }

  void _initialize(
    CompetitionPreviewEventInitialize event,
    Emitter<CompetitionPreviewState> emit,
  ) {
    _competitionListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _competitionRepository.getCompetitionById(
            competitionId: event.competitionId,
            userId: loggedUserId,
          ),
        )
        .listen(
          (Competition? competition) => add(
            CompetitionPreviewEventCompetitionUpdated(
              competition: competition,
            ),
          ),
        );
  }

  void _competitionUpdated(
    CompetitionPreviewEventCompetitionUpdated event,
    Emitter<CompetitionPreviewState> emit,
  ) {
    emit(state.copyWith(
      competition: event.competition,
    ));
  }

  Future<void> _deleteCompetition(
    CompetitionPreviewEventDeleteCompetition event,
    Emitter<CompetitionPreviewState> emit,
  ) async {
    final String? competitionId = state.competition?.id;
    if (competitionId == null) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _competitionRepository.deleteCompetition(
      competitionId: competitionId,
      userId: loggedUserId,
    );
    emitCompleteStatus(
      emit,
      CompetitionPreviewBlocInfo.competitionDeleted,
    );
  }
}

enum CompetitionPreviewBlocInfo {
  competitionDeleted,
}
