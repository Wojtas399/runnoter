import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../entity/race.dart';
import '../../repository/race_repository.dart';
import '../../service/auth_service.dart';

class RacesCubit extends Cubit<List<Race>?> {
  final AuthService _authService;
  final RaceRepository _raceRepository;
  StreamSubscription<List<Race>?>? _racesListener;

  RacesCubit({
    required AuthService authService,
    required RaceRepository raceRepository,
  })  : _authService = authService,
        _raceRepository = raceRepository,
        super(null);

  @override
  Future<void> close() {
    _racesListener?.cancel();
    _racesListener = null;
    return super.close();
  }

  void initialize() {
    _racesListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _raceRepository.getAllRaces(
            userId: loggedUserId,
          ),
        )
        .listen(_emitSortedRaces);
  }

  void _emitSortedRaces(List<Race>? races) {
    if (races == null) {
      emit(null);
      return;
    }
    final List<Race> sortedRaces = [...races];
    sortedRaces.sort(_compareDatesOfRaces);
    emit(sortedRaces);
  }

  int _compareDatesOfRaces(
    Race race1,
    Race race2,
  ) =>
      race1.date.isBefore(race2.date)
          ? 1
          : race1.date.isAfter(race2.date)
              ? -1
              : 0;
}
