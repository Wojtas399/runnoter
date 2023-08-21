import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import '../entity/race.dart';
import '../repository/race_repository.dart';

class RacesCubit extends Cubit<List<RacesFromYear>?> {
  final String _userId;
  final RaceRepository _raceRepository;
  StreamSubscription<List<Race>?>? _racesListener;

  RacesCubit({required String userId})
      : _userId = userId,
        _raceRepository = getIt<RaceRepository>(),
        super(null);

  @override
  Future<void> close() {
    _racesListener?.cancel();
    _racesListener = null;
    return super.close();
  }

  void initialize() {
    _racesListener ??=
        _raceRepository.getAllRaces(userId: _userId).listen(_onRacesChanged);
  }

  void _onRacesChanged(List<Race>? races) {
    if (races == null) return;
    final groupedRaces = _groupRaces(races);
    groupedRaces.sort((g1, g2) => g2.year < g1.year ? -1 : 1);
    for (final racesFromYear in groupedRaces) {
      racesFromYear.races.sort((r1, r2) => r2.date.compareTo(r1.date));
    }
    emit(groupedRaces);
  }

  List<RacesFromYear> _groupRaces(List<Race> races) {
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

  const RacesFromYear({required this.year, required this.races});

  @override
  List<Object?> get props => [year, races];
}
