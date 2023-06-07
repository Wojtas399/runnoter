import 'package:firebase/firebase.dart';

import '../../domain/entity/competition.dart';
import 'run_status_mapper.dart';

Competition mapCompetitionFromDto(CompetitionDto competitionDto) => Competition(
      id: competitionDto.id,
      userId: competitionDto.userId,
      name: competitionDto.name,
      date: competitionDto.date,
      place: competitionDto.place,
      distance: competitionDto.distance,
      expectedDuration: competitionDto.expectedDuration,
      status: mapRunStatusFromDto(competitionDto.statusDto),
    );

CompetitionDto mapCompetitionToDto(Competition competition) => CompetitionDto(
      id: competition.id,
      userId: competition.userId,
      name: competition.name,
      date: competition.date,
      place: competition.place,
      distance: competition.distance,
      expectedDuration: competition.expectedDuration,
      statusDto: mapRunStatusToDto(competition.status),
    );
