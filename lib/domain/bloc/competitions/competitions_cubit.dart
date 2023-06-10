import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../entity/competition.dart';
import '../../repository/competition_repository.dart';
import '../../service/auth_service.dart';

class CompetitionsCubit extends Cubit<List<Competition>?> {
  final AuthService _authService;
  final CompetitionRepository _competitionRepository;
  StreamSubscription<List<Competition>?>? _competitionsListener;

  CompetitionsCubit({
    required AuthService authService,
    required CompetitionRepository competitionRepository,
  })  : _authService = authService,
        _competitionRepository = competitionRepository,
        super(null);

  @override
  Future<void> close() {
    _competitionsListener?.cancel();
    _competitionsListener = null;
    return super.close();
  }

  void initialize() {
    _competitionsListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _competitionRepository.getAllCompetitions(
            userId: loggedUserId,
          ),
        )
        .listen(_emitSortedCompetitions);
  }

  void _emitSortedCompetitions(List<Competition>? competitions) {
    if (competitions == null) {
      emit(null);
      return;
    }
    final List<Competition> sortedCompetitions = [...competitions];
    sortedCompetitions.sort(_compareDatesOfCompetitions);
    emit(sortedCompetitions);
  }

  int _compareDatesOfCompetitions(
    Competition competition1,
    Competition competition2,
  ) =>
      competition1.date.isBefore(competition2.date)
          ? 1
          : competition1.date.isAfter(competition2.date)
              ? -1
              : 0;
}
