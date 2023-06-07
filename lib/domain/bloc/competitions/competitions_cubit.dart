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
        .listen(
          (List<Competition>? competitions) => emit(competitions),
        );
  }
}
