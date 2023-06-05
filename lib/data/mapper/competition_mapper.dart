import 'package:firebase/firebase.dart';

import '../../domain/entity/competition.dart';
import 'run_status_mapper.dart';
import 'time_mapper.dart';

Competition mapCompetitionFromDto(CompetitionDto competitionDto) => Competition(
      id: competitionDto.id,
      userId: competitionDto.userId,
      name: competitionDto.name,
      date: competitionDto.date,
      place: competitionDto.place,
      distance: competitionDto.distance,
      expectedTime: mapTimeFromDto(competitionDto.expectedTimeDto),
      status: mapRunStatusFromDto(competitionDto.runStatusDto),
    );

CompetitionDto mapCompetitionToDto(Competition competition) => CompetitionDto(
      id: competition.id,
      userId: competition.userId,
      name: competition.name,
      date: competition.date,
      place: competition.place,
      distance: competition.distance,
      expectedTimeDto: mapTimeToDto(competition.expectedTime),
      runStatusDto: mapRunStatusToDto(competition.status),
    );
