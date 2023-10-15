import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/entity/race.dart';
import '../../../../data/interface/repository/race_repository.dart';
import '../../../../dependency_injection.dart';
import '../../../../domain/additional_model/elements_from_year.dart';

class RacesCubit extends Cubit<List<RacesFromYear>?> {
  final String userId;
  final RaceRepository _raceRepository;
  StreamSubscription<List<Race>?>? _racesListener;

  RacesCubit({required this.userId})
      : _raceRepository = getIt<RaceRepository>(),
        super(null);

  @override
  Future<void> close() {
    _racesListener?.cancel();
    _racesListener = null;
    return super.close();
  }

  void initialize() {
    _racesListener ??= _raceRepository
        .getRacesByUserId(userId: userId)
        .listen(_onRacesChanged);
  }

  Future<void> refresh() async {
    await _raceRepository.refreshRacesByUserId(userId: userId);
  }

  void _onRacesChanged(final List<Race>? races) {
    if (races == null) {
      emit([]);
      return;
    }
    final groupedAndSortedRaces = _groupRaces(races);
    groupedAndSortedRaces.sort((g1, g2) => g2.year < g1.year ? -1 : 1);
    for (final racesFromYear in groupedAndSortedRaces) {
      racesFromYear.elements.sort((r1, r2) => r2.date.compareTo(r1.date));
    }
    emit(groupedAndSortedRaces);
  }

  List<RacesFromYear> _groupRaces(List<Race> races) {
    final List<RacesFromYear> groupedRaces = [];
    for (final race in races) {
      final int year = race.date.year;
      final int yearIndex = groupedRaces.indexWhere(
        (element) => element.year == year,
      );
      if (yearIndex >= 0) {
        groupedRaces[yearIndex].elements.add(race);
      } else {
        groupedRaces.add(
          RacesFromYear(year: year, elements: [race]),
        );
      }
    }
    return groupedRaces;
  }
}

class RacesFromYear extends ElementsFromYear<Race> {
  const RacesFromYear({required super.year, required super.elements});
}
