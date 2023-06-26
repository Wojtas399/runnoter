part of 'race_preview_bloc.dart';

abstract class RacePreviewEvent {
  const RacePreviewEvent();
}

class RacePreviewEventInitialize extends RacePreviewEvent {
  final String raceId;

  const RacePreviewEventInitialize({
    required this.raceId,
  });
}

class RacePreviewEventRaceUpdated extends RacePreviewEvent {
  final Race? race;

  const RacePreviewEventRaceUpdated({
    required this.race,
  });
}

class RacePreviewEventDeleteRace extends RacePreviewEvent {
  const RacePreviewEventDeleteRace();
}
