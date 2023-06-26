import 'package:firebase/firebase.dart';

import '../../domain/entity/race.dart';
import 'run_status_mapper.dart';

Race mapRaceFromDto(RaceDto raceDto) => Race(
      id: raceDto.id,
      userId: raceDto.userId,
      name: raceDto.name,
      date: raceDto.date,
      place: raceDto.place,
      distance: raceDto.distance,
      expectedDuration: raceDto.expectedDuration,
      status: mapRunStatusFromDto(raceDto.statusDto),
    );

RaceDto mapRaceToDto(Race race) => RaceDto(
      id: race.id,
      userId: race.userId,
      name: race.name,
      date: race.date,
      place: race.place,
      distance: race.distance,
      expectedDuration: race.expectedDuration,
      statusDto: mapRunStatusToDto(race.status),
    );
