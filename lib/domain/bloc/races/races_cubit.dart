import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../entity/race.dart';
import '../../repository/race_repository.dart';
import '../../service/auth_service.dart';

class RacesCubit extends Cubit<List<RacesFromYear>?> {
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
        .listen(_onRacesChanged);
  }

  void _onRacesChanged(List<Race>? races) {
    if (races == null) return;
    final segregatedRaces = _segregateRaces(races);
    for (final racesFromYear in segregatedRaces) {
      racesFromYear.races.sort((r1, r2) => r2.date.compareTo(r1.date));
    }
    emit(segregatedRaces);
  }

  List<RacesFromYear> _segregateRaces(List<Race> races) {
    final List<RacesFromYear> segregatedRaces = [];
    for (final race in races) {
      final int year = race.date.year;
      final int yearIndex = segregatedRaces.indexWhere(
        (element) => element.year == year,
      );
      if (yearIndex >= 0) {
        segregatedRaces[yearIndex].races.add(race);
      } else {
        segregatedRaces.add(
          RacesFromYear(year: year, races: [race]),
        );
      }
    }
    return segregatedRaces;
  }
}

class RacesFromYear extends Equatable {
  final int year;
  final List<Race> races;

  const RacesFromYear({
    required this.year,
    required this.races,
  });

  @override
  List<Object?> get props => [
        year,
        races,
      ];
}
