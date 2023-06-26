part of 'race_creator_bloc.dart';

abstract class RaceCreatorEvent {
  const RaceCreatorEvent();
}

class RaceCreatorEventInitialize extends RaceCreatorEvent {
  final String? raceId;

  const RaceCreatorEventInitialize({
    required this.raceId,
  });
}

class RaceCreatorEventNameChanged extends RaceCreatorEvent {
  final String? name;

  const RaceCreatorEventNameChanged({
    required this.name,
  });
}

class RaceCreatorEventDateChanged extends RaceCreatorEvent {
  final DateTime? date;

  const RaceCreatorEventDateChanged({
    required this.date,
  });
}

class RaceCreatorEventPlaceChanged extends RaceCreatorEvent {
  final String? place;

  const RaceCreatorEventPlaceChanged({
    required this.place,
  });
}

class RaceCreatorEventDistanceChanged extends RaceCreatorEvent {
  final double? distance;

  const RaceCreatorEventDistanceChanged({
    required this.distance,
  });
}

class RaceCreatorEventExpectedDurationChanged extends RaceCreatorEvent {
  final Duration? expectedDuration;

  const RaceCreatorEventExpectedDurationChanged({
    required this.expectedDuration,
  });
}

class RaceCreatorEventSubmit extends RaceCreatorEvent {
  const RaceCreatorEventSubmit();
}
